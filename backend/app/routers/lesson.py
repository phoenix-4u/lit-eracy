
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .. import models
from ..schemas.task import TaskOut
from ..database import get_db
from ..services.ai_service import AIService

router = APIRouter()

@router.post("/lessons/{lesson_id}/generate-task", response_model=TaskOut)
async def generate_task_for_lesson(lesson_id: int, db: Session = Depends(get_db)):
    lesson = db.query(models.Lesson).filter(models.Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")

    ai_service = AIService()
    task_data = await ai_service.generate_task_with_ollama(lesson.content)

    if not task_data or 'title' not in task_data or 'description' not in task_data:
        raise HTTPException(status_code=500, detail="Failed to generate task from AI service")

    db_task = models.Task(
        lesson_id=lesson_id,
        title=task_data['title'],
        description=task_data['description']
    )
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task
