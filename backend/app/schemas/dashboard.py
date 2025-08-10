# backend/app/schemas/dashboard.py
from pydantic import BaseModel
from typing import List, Optional, Dict

class PointsOut(BaseModel):
    knowledge_gems: int
    word_coins: int
    imagination_sparks: int
    total_points: int
    current_streak: int
    longest_streak: int
    last_activity_date: Optional[str]

class LessonInfo(BaseModel):
    id: int
    title: str
    subject: str
    grade_level: int
    points_reward: int
    estimated_duration: int

class StudentDashboard(BaseModel):
    num_lessons: int
    points: PointsOut
    recent_lessons: List[LessonInfo]
    recommended_content: List[LessonInfo]
