from pydantic import BaseModel
from datetime import datetime

class AchievementBase(BaseModel):
    name: str

class AchievementOut(AchievementBase):
    id: int
    user_id: int
    earned_at: datetime

    class Config:
        orm_mode = True
