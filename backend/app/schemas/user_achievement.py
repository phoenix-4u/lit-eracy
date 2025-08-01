from pydantic import BaseModel
from datetime import datetime

class UserAchievementResponse(BaseModel):
    id: int
    user_id: int
    achievement_id: int
    earned_at: datetime

    class Config:
        from_attributes = True
