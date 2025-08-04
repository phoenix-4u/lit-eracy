# File: backend/app/schemas.py

from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime
from enum import Enum

class UserRole(str, Enum):
    STUDENT = "student"
    PARENT = "parent"
    TEACHER = "teacher"
    ADMIN = "admin"

class ContentType(str, Enum):
    LESSON = "lesson"
    QUIZ = "quiz"
    STORY = "story"
    ACTIVITY = "activity"

class AchievementType(str, Enum):
    STREAK = "streak"
    POINTS = "points"
    COMPLETION = "completion"
    MILESTONE = "milestone"

# Auth schemas
class UserBase(BaseModel):
    username: str
    email: EmailStr
    full_name: str
    age: Optional[int] = None
    grade: Optional[int] = None
    role: UserRole = UserRole.STUDENT
    parent_email: Optional[str] = None
    avatar_url: Optional[str] = None

class UserCreate(UserBase):
    password: str

class UserLogin(BaseModel):
    username: str
    password: str

class UserResponse(UserBase):
    id: int
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse

# Content schemas
class ContentBase(BaseModel):
    title: str
    description: Optional[str] = None
    content_type: ContentType
    grade_level: int
    subject: str
    content_data: Optional[str] = None
    difficulty_level: int = 1
    estimated_duration: Optional[int] = None
    points_reward: int = 10
    thumbnail_url: Optional[str] = None

class ContentCreate(ContentBase):
    pass

class ContentResponse(ContentBase):
    id: int
    is_ai_generated: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Achievement schemas
class AchievementBase(BaseModel):
    name: str
    description: str
    achievement_type: AchievementType
    badge_icon: Optional[str] = None
    badge_color: Optional[str] = None
    points_required: Optional[int] = None
    streak_days_required: Optional[int] = None
    completion_count_required: Optional[int] = None

class AchievementCreate(AchievementBase):
    pass

class AchievementResponse(AchievementBase):
    id: int
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

class UserAchievementResponse(BaseModel):
    id: int
    achievement: AchievementResponse
    earned_at: datetime
    progress_value: float
    
    class Config:
        from_attributes = True

# Progress schemas
class UserProgressBase(BaseModel):
    content_id: int
    completion_percentage: float = 0.0
    time_spent: int = 0
    score: Optional[float] = None

class UserProgressCreate(UserProgressBase):
    pass

class UserProgressUpdate(BaseModel):
    completion_percentage: Optional[float] = None
    time_spent: Optional[int] = None
    score: Optional[float] = None
    is_completed: Optional[bool] = None

class UserProgressResponse(UserProgressBase):
    id: int
    user_id: int
    is_completed: bool
    attempts: int
    first_attempt_at: datetime
    completed_at: Optional[datetime] = None
    content: ContentResponse
    
    class Config:
        from_attributes = True

# Points schemas
class UserPointsResponse(BaseModel):
    knowledge_gems: int
    word_coins: int
    imagination_sparks: int
    total_points: int
    current_streak: int
    longest_streak: int
    last_activity_date: Optional[datetime] = None
    
    class Config:
        from_attributes = True

# AI schemas
class AIGenerateRequest(BaseModel):
    content_type: str
    grade_level: int
    subject: str
    topic: Optional[str] = None
    difficulty: int = 1
    user_preferences: Optional[dict] = None

class AIGenerateResponse(BaseModel):
    content: ContentResponse
    generation_time: float
    safety_score: float

class AIChatRequest(BaseModel):
    message: str
    context: Optional[str] = None

class AIChatResponse(BaseModel):
    response: str
    is_safe: bool
    confidence: float

# Screen time schemas
class ScreenTimeLogResponse(BaseModel):
    id: int
    session_start: datetime
    session_end: Optional[datetime] = None
    duration_minutes: Optional[int] = None
    activity_type: Optional[str] = None
    device_type: Optional[str] = None
    
    class Config:
        from_attributes = True

class ParentalControlsResponse(BaseModel):
    daily_time_limit_minutes: int
    bedtime_start: Optional[str] = None
    bedtime_end: Optional[str] = None
    allowed_content_grades: Optional[str] = None
    break_reminder_minutes: int
    is_active: bool
    
    class Config:
        from_attributes = True

class ParentalControlsUpdate(BaseModel):
    daily_time_limit_minutes: Optional[int] = None
    bedtime_start: Optional[str] = None
    bedtime_end: Optional[str] = None
    allowed_content_grades: Optional[str] = None
    break_reminder_minutes: Optional[int] = None
    is_active: Optional[bool] = None

# Dashboard schemas
class StudentDashboardResponse(BaseModel):
    user: UserResponse
    points: UserPointsResponse
    recent_achievements: List[UserAchievementResponse]
    current_progress: List[UserProgressResponse]
    recommended_content: List[ContentResponse]
    screen_time_today: int
    streak_info: dict

class ParentDashboardResponse(BaseModel):
    student: UserResponse
    points: UserPointsResponse
    achievements: List[UserAchievementResponse]
    screen_time_logs: List[ScreenTimeLogResponse]
    parental_controls: ParentalControlsResponse
    weekly_progress: dict
    safety_report: dict

class TeacherDashboardResponse(BaseModel):
    classroom_stats: dict
    student_progress: List[dict]
    content_usage: dict
    achievements_summary: dict