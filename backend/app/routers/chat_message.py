# File: backend/app/routers/chat_message.py

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app.models.chat_message import ChatMessage
from app.schemas.chat_message import ChatMessageCreate, ChatMessageOut

router = APIRouter(prefix="/api/chat_messages", tags=["ChatMessages"])

@router.post("", response_model=ChatMessageOut)
def send_message(
    payload: ChatMessageCreate, db: Session = Depends(get_db)
):
    msg = ChatMessage(**payload.dict())
    db.add(msg)
    db.commit()
    db.refresh(msg)
    return msg

@router.get("", response_model=List[ChatMessageOut])
def list_messages(db: Session = Depends(get_db)):
    return db.query(ChatMessage).all()
