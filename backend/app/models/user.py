from sqlalchemy import Boolean, Column, Integer, String, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from ..base import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    username = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String)  # ✅ ADD THIS
    age = Column(Integer)  # ✅ ADD THIS
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())  # ✅ ADD THIS
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())  # ✅ ADD THIS

    # Relationships (if you have them)
    user_progress = relationship("UserProgress", back_populates="user")
    achievements = relationship("UserAchievement", back_populates="user")
    points = relationship("UserPoints", uselist=False, back_populates="user")
