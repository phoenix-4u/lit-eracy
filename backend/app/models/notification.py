# File: backend/app/models/notification.py

from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base
import datetime

class Notification(Base):
    __tablename__ = "notifications"

    id       = Column(Integer, primary_key=True, index=True)
    user_id  = Column(Integer, ForeignKey("users.id"), nullable=False)
    title    = Column(String(255), nullable=False)
    message  = Column(Text, nullable=False)
    sent_at  = Column(DateTime, default=datetime.datetime.utcnow)

    # Ensure this name matches the import
    user = relationship("User", back_populates="notifications")
