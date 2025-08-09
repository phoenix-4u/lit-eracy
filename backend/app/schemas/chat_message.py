# File: backend/app/schemas/chat_message.py

from pydantic import BaseModel
from datetime import datetime

class ChatMessageBase(BaseModel):
    sender_id: int
    receiver_id: int
    message: str

class ChatMessageCreate(ChatMessageBase):
    pass

class ChatMessageOut(ChatMessageBase):
    id: int
    sent_at: datetime

    class Config:
        from_attributes = True
