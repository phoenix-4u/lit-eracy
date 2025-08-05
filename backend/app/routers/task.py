from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from .. import models
from ..schemas.task import TaskCreate, TaskOut
from ..schemas.user import User
from ..database import get_db

router = APIRouter()

@router.post("/", response_model=TaskOut)
async def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    db_task = models.Task(**task.model_dump())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

@router.get("/{task_id}", response_model=TaskOut)
async def get_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return task

@router.get("/lesson/{lesson_id}", response_model=List[TaskOut])
async def get_tasks_for_lesson(lesson_id: int, db: Session = Depends(get_db)):
    tasks = db.query(models.Task).filter(models.Task.lesson_id == lesson_id).all()
    return tasks

@router.post("/{task_id}/complete", response_model=TaskOut)
async def complete_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    task.is_completed = 1
    db.commit()
    db.refresh(task)
    return task
