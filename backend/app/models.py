# File: backend/app/models.py

from sqlalchemy import Column, Integer, String, DateTime, Boolean, Text, ForeignKey, Float, Enum
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from datetime import datetime
import enum
from .database import Base

class UserRole(enum.Enum):
    STUDENT = "student"
    PARENT = "parent"
    TEACHER = "teacher"
    ADMIN = "admin"

class ContentType(enum.Enum):
    LESSON = "lesson"
    QUIZ = "quiz"
    STORY = "story"
    ACTIVITY = "activity"

class AchievementType(enum.Enum):
    STREAK = "streak"
    POINTS = "points"
    COMPLETION = "completion"
    MILESTONE = "milestone"

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String, nullable=False)
    age = Column(Integer)
    grade = Column(Integer)
    role = Column(Enum(UserRole), default=UserRole.STUDENT)
    parent_email = Column(String)  # For students
    is_active = Column(Boolean, default=True)
    avatar_url = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    progress = relationship("UserProgress", back_populates="user")
    achievements = relationship("UserAchievement", back_populates="user")
    screen_time_logs = relationship("ScreenTimeLog", back_populates="user")
    ai_interactions = relationship("AIInteraction", back_populates="user")

class Content(Base):
    __tablename__ = "content"
    
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(Text)
    content_type = Column(Enum(ContentType), nullable=False)
    grade_level = Column(Integer, nullable=False)
    subject = Column(String, nullable=False)
    content_data = Column(Text)  # JSON string for flexible content
    difficulty_level = Column(Integer, default=1)  # 1-5 scale
    estimated_duration = Column(Integer)  # in minutes
    points_reward = Column(Integer, default=10)
    is_ai_generated = Column(Boolean, default=False)
    thumbnail_url = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    progress = relationship("UserProgress", back_populates="content")

class Achievement(Base):
    __tablename__ = "achievements"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    achievement_type = Column(Enum(AchievementType), nullable=False)
    badge_icon = Column(String)
    badge_color = Column(String)
    points_required = Column(Integer)
    streak_days_required = Column(Integer)
    completion_count_required = Column(Integer)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    user_achievements = relationship("UserAchievement", back_populates="achievement")

class UserAchievement(Base):
    __tablename__ = "user_achievements"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    achievement_id = Column(Integer, ForeignKey("achievements.id"), nullable=False)
    earned_at = Column(DateTime(timezone=True), server_default=func.now())
    progress_value = Column(Float, default=0.0)  # For tracking partial progress
    
    # Relationships
    user = relationship("User", back_populates="achievements")
    achievement = relationship("Achievement", back_populates="user_achievements")

class UserProgress(Base):
    __tablename__ = "user_progress"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    content_id = Column(Integer, ForeignKey("content.id"), nullable=False)
    is_completed = Column(Boolean, default=False)
    completion_percentage = Column(Float, default=0.0)
    time_spent = Column(Integer, default=0)  # in seconds
    score = Column(Float)
    attempts = Column(Integer, default=0)
    first_attempt_at = Column(DateTime(timezone=True), server_default=func.now())
    completed_at = Column(DateTime(timezone=True))
    
    # Relationships
    user = relationship("User", back_populates="progress")
    content = relationship("Content", back_populates="progress")

class UserPoints(Base):
    __tablename__ = "user_points"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    knowledge_gems = Column(Integer, default=0)
    word_coins = Column(Integer, default=0)
    imagination_sparks = Column(Integer, default=0)
    total_points = Column(Integer, default=0)
    current_streak = Column(Integer, default=0)
    longest_streak = Column(Integer, default=0)
    last_activity_date = Column(DateTime(timezone=True))
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

class ScreenTimeLog(Base):
    __tablename__ = "screen_time_logs"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    session_start = Column(DateTime(timezone=True), nullable=False)
    session_end = Column(DateTime(timezone=True))
    duration_minutes = Column(Integer)
    activity_type = Column(String)  # lesson, quiz, free_play, etc.
    device_type = Column(String)
    
    # Relationships
    user = relationship("User", back_populates="screen_time_logs")

class ParentalControls(Base):
    __tablename__ = "parental_controls"
    
    id = Column(Integer, primary_key=True, index=True)
    student_user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    parent_user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    daily_time_limit_minutes = Column(Integer, default=60)
    bedtime_start = Column(String)  # Time in HH:MM format
    bedtime_end = Column(String)    # Time in HH:MM format
    allowed_content_grades = Column(String)  # JSON array of allowed grades
    break_reminder_minutes = Column(Integer, default=15)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

class AIInteraction(Base):
    __tablename__ = "ai_interactions"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    interaction_type = Column(String, nullable=False)  # story_generation, quiz_help, etc.
    user_input = Column(Text)
    ai_response = Column(Text)
    feedback_rating = Column(Integer)  # 1-5 rating
    is_appropriate = Column(Boolean, default=True)
    processing_time = Column(Float)  # in seconds
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    user = relationship("User", back_populates="ai_interactions")

class Classroom(Base):
    __tablename__ = "classrooms"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    grade_level = Column(Integer, nullable=False)
    teacher_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    school_name = Column(String)
    class_code = Column(String, unique=True, index=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class ClassroomStudent(Base):
    __tablename__ = "classroom_students"
    
    id = Column(Integer, primary_key=True, index=True)
    classroom_id = Column(Integer, ForeignKey("classrooms.id"), nullable=False)
    student_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    joined_at = Column(DateTime(timezone=True), server_default=func.now())
    is_active = Column(Boolean, default=True)