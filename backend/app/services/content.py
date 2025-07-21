from ..models.lesson import Lesson
from ..database import SessionLocal

async def get_lessons(user_id: int):
    db = SessionLocal()
    lessons = db.query(Lesson).filter(Lesson.grade == user_id).all()
    db.close()
    return lessons