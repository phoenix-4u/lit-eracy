from ..models.achievement import Achievement
from ..database import SessionLocal

async def get_achievements(user_id: int):
    db = SessionLocal()
    items = db.query(Achievement).filter(Achievement.user_id == user_id).all()
    db.close()
    return items
