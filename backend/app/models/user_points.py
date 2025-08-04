# File: backend/app/models/user_points.py

from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship
from ..database import Base
from .user import User

class UserPoints(Base):
    __tablename__ = "user_points"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey(User.id), nullable=False)
    points = Column(Integer, default=0)

    user = relationship("User", back_populates="points")
