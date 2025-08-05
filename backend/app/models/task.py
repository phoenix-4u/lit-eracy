from sqlalchemy import Column, Integer, String, Text, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from ..base import Base
import datetime


class Task(Base):
    __tablename__ = "tasks"
    
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    lesson_id = Column(Integer, ForeignKey("lessons.id"), nullable=False)
    is_completed = Column(Integer, default=0)  # 0 = incomplete, 1 = complete
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    
    # Relationship to lesson
    lesson = relationship("Lesson", back_populates="tasks")
