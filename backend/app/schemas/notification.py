# File: backend/app/schemas/notification.py

from pydantic import BaseModel
from datetime import datetime

class NotificationBase(BaseModel):
    user_id: int
    title: str
    message: str

class NotificationCreate(NotificationBase):
    pass

class NotificationOut(NotificationBase):
    id: int
    sent_at: datetime

    class Config:
        from_attributes = True
