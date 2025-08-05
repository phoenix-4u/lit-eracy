# File: backend/app/routers/lesson.py

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .. import models
from ..schemas.task import TaskOut
from ..database import get_db
from ..services.ai_service import AIService

router = APIRouter()

@router.post("/lessons/{lesson_id}/generate-task", response_model=TaskOut)
async def generate_task_for_lesson(lesson_id: int, db: Session = Depends(get_db)):
    # Get the lesson first
    lesson = db.query(models.Lesson).filter(models.Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")

    try:
        # Use AI service to generate task
        ai_service = AIService()
        task_data = await ai_service.generate_task_with_ollama(lesson.content or lesson.title)
        
        if not task_data:
            # Fallback if AI fails
            task_data = {
                "title": f"Practice {lesson.title}",
                "description": f"Complete exercises related to {lesson.title}. Practice the concepts and skills covered in this lesson."
            }
        
        # Create the task in database
        db_task = models.Task(
            lesson_id=lesson_id,
            title=task_data['title'],
            description=task_data['description'],
            is_completed=0
        )
        
        db.add(db_task)
        db.commit()
        db.refresh(db_task)
        
        return db_task
        
    except Exception as e:
        # If AI generation fails, create a simple fallback task
        db_task = models.Task(
            lesson_id=lesson_id,
            title=f"Learning Activity: {lesson.title}",
            description=f"Practice and review the concepts from '{lesson.title}'. Work through examples and apply what you've learned.",
            is_completed=0
        )
        
        db.add(db_task)
        db.commit()
        db.refresh(db_task)
        
        return db_task
