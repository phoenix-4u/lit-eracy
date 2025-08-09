# File: backend/app/routers/task.py

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from .. import models
from ..schemas.task import TaskCreate, TaskOut
from ..schemas.user_points import UserPointsOut
from ..database import get_db
from ..routers.auth import get_current_active_user

router = APIRouter()

@router.post("/", response_model=TaskOut)
async def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    db_task = models.Task(**task.model_dump())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

# FIX: This endpoint should return a single task, not wrapped in data
@router.get("/{task_id}", response_model=TaskOut)
async def get_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    # Return the task directly - your frontend expects it wrapped in 'data'
    return task

@router.get("/lesson/{lesson_id}", response_model=List[TaskOut])
async def get_tasks_for_lesson(lesson_id: int, db: Session = Depends(get_db)):
    tasks = db.query(models.Task).filter(models.Task.lesson_id == lesson_id).all()
    return tasks

@router.post("/{task_id}/complete", response_model=TaskOut)
async def complete_task(
    task_id: int, 
    db: Session = Depends(get_db), 
    current_user: models.User = Depends(get_current_active_user)
):
    task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    if task.is_completed:
        raise HTTPException(status_code=400, detail="Task already completed")

    task.is_completed = True

    # Award points
    user_points = db.query(models.UserPoints).filter(models.UserPoints.user_id == current_user.id).first()
    if not user_points:
        user_points = models.UserPoints(user_id=current_user.id, knowledge_gems=10)
        db.add(user_points)
    else:
        user_points.knowledge_gems += 10
    
    db.commit()
    db.refresh(task)
    return task

@router.get("/points", response_model=UserPointsOut)
async def get_user_points(
    db: Session = Depends(get_db), 
    current_user: models.User = Depends(get_current_active_user)
):
    user_points = db.query(models.UserPoints).filter(models.UserPoints.user_id == current_user.id).first()
    if not user_points:
        # Create a points entry if it doesn't exist
        user_points = models.UserPoints(user_id=current_user.id)
        db.add(user_points)
        db.commit()
        db.refresh(user_points)
    return user_points
