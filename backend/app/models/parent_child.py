# File: backend/app/models/parent_child.py

from sqlalchemy import Column, Integer, ForeignKey, DateTime, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from ..base import Base

class ParentChild(Base):
    __tablename__ = "parent_children"

    id = Column(Integer, primary_key=True, index=True)
    parent_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    child_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    is_active = Column(Boolean, default=True)
    linked_at = Column(DateTime(timezone=True), server_default=func.now())

    parent = relationship("User", foreign_keys=[parent_id], back_populates="children")
    child = relationship("User", foreign_keys=[child_id], back_populates="parents")
