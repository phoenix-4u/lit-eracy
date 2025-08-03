# File: backend/app/models.py

from sqlalchemy import Column, Integer, String, DateTime, Boolean, Text, ForeignKey, Float
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from datetime import datetime
from .database import Base

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, index=True, nullable=False)
    email = Column(String(100), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    full_name = Column(String(100), nullable=False)
    age = Column(Integer)
    grade = Column(Integer)
    role = Column(String(20), default="student")  # student, parent, teacher, admin
    parent_email = Column(String(100))  # For students
    is_active = Column(Boolean, default=True)
    avatar_url = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    progress = relationship("UserProgress", back_populates="user", cascade="all, delete-orphan")
    achievements = relationship("UserAchievement", back_populates="user", cascade="all, delete-orphan")
    screen_time_logs = relationship("ScreenTimeLog", back_populates="user", cascade="all, delete-orphan")
    ai_interactions = relationship("AIInteraction", back_populates="user", cascade="all, delete-orphan")
    points = relationship("UserPoints", back_populates="user", uselist=False, cascade="all, delete-orphan")

class Content(Base):
    __tablename__ = "content"
    
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(200), nullable=False)
    description = Column(Text)
    content_type = Column(String(20), nullable=False)  # lesson, quiz, story, activity
    grade_level = Column(Integer, nullable=False)
    subject = Column(String(50), nullable=False)
    content_data = Column(Text)  # JSON string for flexible content
    difficulty_level = Column(Integer, default=1)  # 1-5 scale
    estimated_duration = Column(Integer)  # in minutes
    points_reward = Column(Integer, default=10)
    is_ai_generated = Column(Boolean, default=False)
    thumbnail_url = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    progress = relationship("UserProgress", back_populates="content", cascade="all, delete-orphan")

class Achievement(Base):
    __tablename__ = "achievements"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)
    achievement_type = Column(String(20), nullable=False)  # streak, points, completion, milestone
    badge_icon = Column(String(50))
    badge_color = Column(String(20))
    points_required = Column(Integer)
    streak_days_required = Column(Integer)
    completion_count_required = Column(Integer)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    user_achievements = relationship("UserAchievement", back_populates="achievement", cascade="all, delete-orphan")

class UserAchievement(Base):
    __tablename__ = "user_achievements"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    achievement_id = Column(Integer, ForeignKey("achievements.id"), nullable=False)
    earned_at = Column(DateTime, default=datetime.utcnow)
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
    first_attempt_at = Column(DateTime, default=datetime.utcnow)
    completed_at = Column(DateTime)
    
    # Relationships
    user = relationship("User", back_populates="progress")
    content = relationship("Content", back_populates="progress")

class UserPoints(Base):
    __tablename__ = "user_points"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, unique=True)
    knowledge_gems = Column(Integer, default=0)
    word_coins = Column(Integer, default=0)
    imagination_sparks = Column(Integer, default=0)
    total_points = Column(Integer, default=0)
    current_streak = Column(Integer, default=0)
    longest_streak = Column(Integer, default=0)
    last_activity_date = Column(DateTime)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    user = relationship("User", back_populates="points")

class ScreenTimeLog(Base):
    __tablename__ = "screen_time_logs"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    session_start = Column(DateTime, nullable=False)
    session_end = Column(DateTime)
    duration_minutes = Column(Integer)
    activity_type = Column(String(50))  # lesson, quiz, free_play, etc.
    device_type = Column(String(50))
    
    # Relationships
    user = relationship("User", back_populates="screen_time_logs")

class ParentalControls(Base):
    __tablename__ = "parental_controls"
    
    id = Column(Integer, primary_key=True, index=True)
    student_user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    parent_user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    daily_time_limit_minutes = Column(Integer, default=60)
    bedtime_start = Column(String(10))  # Time in HH:MM format
    bedtime_end = Column(String(10))    # Time in HH:MM format
    allowed_content_grades = Column(Text)  # JSON array of allowed grades
    break_reminder_minutes = Column(Integer, default=15)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class AIInteraction(Base):
    __tablename__ = "ai_interactions"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    interaction_type = Column(String(50), nullable=False)  # story_generation, quiz_help, etc.
    user_input = Column(Text)
    ai_response = Column(Text)
    feedback_rating = Column(Integer)  # 1-5 rating
    is_appropriate = Column(Boolean, default=True)
    processing_time = Column(Float)  # in seconds
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    user = relationship("User", back_populates="ai_interactions")

class Classroom(Base):
    __tablename__ = "classrooms"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    grade_level = Column(Integer, nullable=False)
    teacher_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    school_name = Column(String(100))
    class_code = Column(String(20), unique=True, index=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

class ClassroomStudent(Base):
    __tablename__ = "classroom_students"
    
    id = Column(Integer, primary_key=True, index=True)
    classroom_id = Column(Integer, ForeignKey("classrooms.id"), nullable=False)
    student_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    joined_at = Column(DateTime, default=datetime.utcnow)
    is_active = Column(Boolean, default=True)