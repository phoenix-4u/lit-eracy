from pydantic import BaseModel

class LessonBase(BaseModel):
    grade: int
    title: str
    content: str

class LessonOut(LessonBase):
    id: int

    class Config:
        orm_mode = True
