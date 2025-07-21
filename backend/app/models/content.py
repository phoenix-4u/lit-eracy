# backend/app/models/content.py

from sqlalchemy import Column, Integer, String, Text, Boolean, DateTime, func
from ..database import Base

class Content(Base):
    __tablename__ = "contents"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(Text)
    content_type = Column(String, nullable=False)
    difficulty_level = Column(Integer, default=1)
    age_group = Column(String)
    content_data = Column(Text)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
