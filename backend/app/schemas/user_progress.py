from pydantic import BaseModel

class UserProgressBase(BaseModel):
    user_id: int
    lesson_id: int
    task_id: int
    is_completed: bool

class UserProgressCreate(UserProgressBase):
    pass

class UserProgressResponse(UserProgressBase):
    id: int

    class Config:
        from_attributes = True