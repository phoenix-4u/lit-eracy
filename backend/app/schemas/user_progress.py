# File: backend/app/schemas/user_progress.py

from pydantic import BaseModel

class UserProgressBase(BaseModel):
    content_id: int  # renamed from lesson_id/task_id to match 'content_id'
    completion_percentage: float
    time_spent: int
    is_completed: bool = False

class UserProgressCreate(UserProgressBase):
    pass

class UserProgressResponse(UserProgressBase):
    user_id: int

    class Config:
        from_attributes = True