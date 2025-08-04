# File: backend/app/schemas/user_points.py

from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class UserPointsBase(BaseModel):
    """Base schema for UserPoints with common fields"""
    knowledge_gems: int = Field(default=0, ge=0, description="Knowledge gems earned")
    word_coins: int = Field(default=0, ge=0, description="Word coins earned")
    imagination_sparks: int = Field(default=0, ge=0, description="Imagination sparks earned")
    total_points: int = Field(default=0, ge=0, description="Total points accumulated")
    current_streak: int = Field(default=0, ge=0, description="Current daily streak")
    longest_streak: int = Field(default=0, ge=0, description="Longest streak achieved")

class UserPointsCreate(UserPointsBase):
    """Schema for creating new UserPoints"""
    user_id: int = Field(..., description="ID of the user these points belong to")

class UserPointsUpdate(BaseModel):
    """Schema for updating UserPoints"""
    knowledge_gems: Optional[int] = Field(None, ge=0)
    word_coins: Optional[int] = Field(None, ge=0)
    imagination_sparks: Optional[int] = Field(None, ge=0)
    current_streak: Optional[int] = Field(None, ge=0)
    last_activity_date: Optional[datetime] = None
