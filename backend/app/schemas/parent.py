# File: backend/app/schemas/parent.py

from pydantic import BaseModel, Field
from datetime import datetime
from typing import List, Optional

class ChildSummary(BaseModel):
    id: int
    username: str
    full_name: str
    age: Optional[int]
    grade: Optional[int]
    avatar_url: Optional[str]
    last_activity: Optional[datetime]
    is_active: bool

class ChildPoints(BaseModel):
    knowledge_gems: int
    word_coins: int
    imagination_sparks: int
    total_points: int
    current_streak: int
    longest_streak: int

class ChildProgress(BaseModel):
    total_lessons: int
    completed_lessons: int
    completion_percentage: float
    time_spent_today: int
    time_spent_week: int

class ChildDashboardData(BaseModel):
    child: ChildSummary
    points: ChildPoints
    progress: ChildProgress
    recent_achievements: List[dict]
    recent_activities: List[dict]

class ParentDashboardResponse(BaseModel):
    parent_info: dict
    children: List[ChildDashboardData]
    family_stats: dict

class LinkChildRequest(BaseModel):
    child_email: str = Field(..., description="Email of the child to link")

class LinkChildResponse(BaseModel):
    success: bool
    message: str
    child_id: Optional[int]
