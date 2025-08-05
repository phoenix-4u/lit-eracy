# File: backend/app/schemas/task.py

from pydantic import BaseModel
from typing import Optional

class TaskBase(BaseModel):
    title: str
    description: str
    lesson_id: int

class TaskCreate(TaskBase):
    pass

class TaskOut(TaskBase):
    id: int
    is_completed: int = 0
    
    class Config:
        from_attributes = True
