from pydantic import BaseModel
from datetime import datetime

class AchievementCreate(BaseModel):
    name: str
from datetime import datetime

class AchievementBase(BaseModel):
    name: str

class AchievementResponse(AchievementBase):
    id: int
    user_id: int
    earned_at: datetime

    class Config:
        from_attributes = True