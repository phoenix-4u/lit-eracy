from pydantic import BaseModel

class TaskBase(BaseModel):
    lesson_id: int
    title: str
    description: str

class TaskCreate(TaskBase):
    pass

class TaskOut(TaskBase):
    id: int
    is_completed: int
    class Config:
        from_attributes = True
