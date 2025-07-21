from pydantic import BaseModel, EmailStr, ConfigDict
from datetime import datetime
from typing import Optional, List
from enum import Enum


class ContentType(str, Enum):
    LESSON = "lesson"
    QUIZ = "quiz"
    GAME = "game"


class AgeGroup(str, Enum):
    PRESCHOOL = "3-6"
    ELEMENTARY = "7-10"
    MIDDLE = "11-14"


# User Schemas
class UserBase(BaseModel):
    email: EmailStr
    username: str
    full_name: Optional[str] = None
    age: Optional[int] = None


class UserCreate(UserBase):
    password: str


class UserUpdate(BaseModel):
    email: Optional[EmailStr] = None
    username: Optional[str] = None
    full_name: Optional[str] = None
    age: Optional[int] = None


class UserResponse(UserBase):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None


class UserLogin(BaseModel):
    email: EmailStr
    password: str


# Content Schemas
class ContentBase(BaseModel):
    title: str
    description: Optional[str] = None
    content_type: ContentType
    difficulty_level: Optional[int] = 1
    age_group: Optional[AgeGroup] = None
    content_data: Optional[str] = None


class ContentCreate(ContentBase):
    pass


class ContentUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    content_type: Optional[ContentType] = None
    difficulty_level: Optional[int] = None
    age_group: Optional[AgeGroup] = None
    content_data: Optional[str] = None
    is_active: Optional[bool] = None


class ContentResponse(ContentBase):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None


# Progress Schemas
class UserProgressBase(BaseModel):
    user_id: int
    content_id: int
    is_completed: Optional[bool] = False
    score: Optional[int] = None
    time_spent: Optional[int] = None


class UserProgressCreate(UserProgressBase):
    pass


class UserProgressUpdate(BaseModel):
    is_completed: Optional[bool] = None
    score: Optional[int] = None
    time_spent: Optional[int] = None


class UserProgressResponse(UserProgressBase):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    completed_at: Optional[datetime] = None
    created_at: datetime
    updated_at: Optional[datetime] = None


# Achievement Schemas
class AchievementBase(BaseModel):
    name: str
    description: Optional[str] = None
    badge_icon: Optional[str] = None
    requirements: Optional[str] = None
    points: Optional[int] = 0


class AchievementCreate(AchievementBase):
    pass


class AchievementUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    badge_icon: Optional[str] = None
    requirements: Optional[str] = None
    points: Optional[int] = None
    is_active: Optional[bool] = None


class AchievementResponse(AchievementBase):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    is_active: bool
    created_at: datetime


class UserAchievementResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    user_id: int
    achievement_id: int
    earned_at: datetime
    achievement: AchievementResponse


# Token Schemas
class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    email: Optional[str] = None
