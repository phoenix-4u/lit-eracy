from sqlalchemy import Column, Integer, String, DateTime
from ..database import Base
import datetime
from sqlalchemy.orm import relationship

class Achievement(Base):
    __tablename__ = "achievements"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    name = Column(String, index=True)
    earned_at = Column(DateTime, default=datetime.datetime.utcnow)
    user_achievements = relationship("UserAchievement", back_populates="achievement")
