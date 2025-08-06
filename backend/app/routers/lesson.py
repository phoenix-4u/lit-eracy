# File: backend/app/routers/lesson.py

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app.models.lesson import Lesson
from app.models.task import Task
from app.schemas.task import TaskOut
from app.services.ai_service import AIService
import logging

logger = logging.getLogger(__name__)

router = APIRouter()

@router.post("/lessons/{lesson_id}/generate-task", response_model=TaskOut)
async def generate_task_for_lesson(lesson_id: int, db: Session = Depends(get_db)):
    """Generate an AI-powered task for a specific lesson."""
    
    # Get the lesson first
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")

    try:
        # Initialize AI service
        ai_service = AIService()
        
        # Prepare lesson content for AI
        lesson_text = lesson.content or lesson.title or "General learning activity"
        grade_level = getattr(lesson, 'grade', None) or getattr(lesson, 'grade_level', None)
        
        logger.info(f"Generating task for lesson {lesson_id}: {lesson.title} for grade {grade_level}")
        
        # Try to generate task with AI
        task_data = await ai_service.generate_task_with_ollama(
            lesson_content=lesson_text,
            grade_level=grade_level
        )
        
        # If AI generation fails, use fallback
        if not task_data:
            logger.warning(f"AI generation failed for lesson {lesson_id}, using fallback")
            task_data = ai_service.generate_fallback_task(lesson_text, grade_level)
        
        # Create the task in database
        db_task = Task(
            lesson_id=lesson_id,
            title=task_data['title'],
            description=task_data['description'],
            is_completed=0,
            # Add additional fields if your Task model has them
            # difficulty_level="medium",
            # estimated_duration=15,
            # task_type="ai_generated"
        )
        
        db.add(db_task)
        db.commit()
        db.refresh(db_task)
        
        logger.info(f"Successfully created AI task {db_task.id} for lesson {lesson_id}")
        return db_task
        
    except Exception as e:
        logger.error(f"Error generating task for lesson {lesson_id}: {e}")
        db.rollback()
        
        # Create a simple fallback task even if everything fails
        try:
            ai_service = AIService()
            fallback_data = ai_service.generate_fallback_task(
                lesson_text=lesson.content or lesson.title,
                grade_level=getattr(lesson, 'grade', None)
            )
            
            db_task = Task(
                lesson_id=lesson_id,
                title=fallback_data['title'],
                description=fallback_data['description'],
                is_completed=0
            )
            
            db.add(db_task)
            db.commit()
            db.refresh(db_task)
            
            logger.info(f"Created fallback task {db_task.id} for lesson {lesson_id}")
            return db_task
            
        except Exception as fallback_error:
            logger.error(f"Even fallback task creation failed: {fallback_error}")
            db.rollback()
            raise HTTPException(
                status_code=500, 
                detail="Failed to generate task. Please try again later."
            )

@router.get("/lessons", response_model=List[dict])
async def get_lessons(db: Session = Depends(get_db)):
    """Get all lessons."""
    lessons = db.query(Lesson).all()
    return [
        {
            "id": lesson.id,
            "title": lesson.title,
            "content": lesson.content,
            "grade": getattr(lesson, 'grade', None),
        }
        for lesson in lessons
    ]

@router.get("/lessons/{lesson_id}")
async def get_lesson(lesson_id: int, db: Session = Depends(get_db)):
    """Get a specific lesson."""
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
    return lesson
