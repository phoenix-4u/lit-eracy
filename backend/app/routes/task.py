from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from .. import models
from ..schemas.task import TaskCreate, TaskOut
from ..schemas.user import User
from ..database import get_db
from ..services.auth import get_current_active_user

router = APIRouter()

@router.post("/tasks/", response_model=TaskOut)
async def create_task(task: TaskCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_active_user)):
    db_task = models.Task(**task.model_dump())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

@router.get("/tasks/{lesson_id}", response_model=List[TaskOut])
async def get_tasks_for_lesson(lesson_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_active_user)):
    tasks = db.query(models.Task).filter(models.Task.lesson_id == lesson_id).all()
    return tasks

@router.post("/tasks/{task_id}/complete", response_model=TaskOut)
async def complete_task(task_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_active_user)):
    task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    task.is_completed = 1
    db.commit()
    db.refresh(task)
    return task
