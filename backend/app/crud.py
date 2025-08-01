from sqlalchemy.orm import Session
from sqlalchemy import and_
from typing import Optional, List
from . import models
from .schemas.user import UserCreate, UserUpdate
from .schemas.content import ContentCreate, ContentUpdate
from .schemas.lesson import LessonOut
from .schemas.achievement import AchievementCreate
from .schemas.user_progress import UserProgressCreate
from .utils.auth import get_password_hash, verify_password


# User CRUD operations
def get_user(db: Session, user_id: int) -> Optional[models.User]:
    """Get user by ID"""
    return db.query(models.User).filter(models.User.id == user_id).first()


def get_user_by_email(db: Session, email: str) -> Optional[models.User]:
    """Get user by email"""
    return db.query(models.User).filter(models.User.email == email).first()


def get_user_by_username(db: Session, username: str) -> Optional[models.User]:
    """Get user by username"""
    return db.query(models.User).filter(models.User.username == username).first()


def get_users(db: Session, skip: int = 0, limit: int = 100) -> List[models.User]:
    """Get users with pagination"""
    return db.query(models.User).offset(skip).limit(limit).all()


def create_user(db: Session, user: UserCreate) -> models.User:
    """Create new user"""
    hashed_password = get_password_hash(user.password)
    db_user = models.User(
        email=user.email,
        username=user.username,
        full_name=user.full_name,
        age=user.age,
        hashed_password=hashed_password
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def update_user(db: Session, user_id: int, user_update: UserUpdate) -> Optional[models.User]:
    """Update user"""
    db_user = db.query(models.User).filter(models.User.id == user_id).first()
    if db_user:
        update_data = user_update.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_user, field, value)
        db.commit()
        db.refresh(db_user)
    return db_user


def delete_user(db: Session, user_id: int) -> bool:
    """Delete user"""
    db_user = db.query(models.User).filter(models.User.id == user_id).first()
    if db_user:
        db.delete(db_user)
        db.commit()
        return True
    return False


def authenticate_user(db: Session, email: str, password: str) -> Optional[models.User]:
    """Authenticate user"""
    user = get_user_by_email(db, email)
    if not user:
        return None
    if not verify_password(password, user.hashed_password):
        return None
    return user


# Content CRUD operations
def get_content(db: Session, content_id: int) -> Optional[models.Content]:
    """Get content by ID"""
    return db.query(models.Content).filter(models.Content.id == content_id).first()


def get_contents(db: Session, skip: int = 0, limit: int = 100, content_type: Optional[str] = None, 
                age_group: Optional[str] = None) -> List[models.Content]:
    """Get contents with filters"""
    query = db.query(models.Content).filter(models.Content.is_active == True)
    
    if content_type:
        query = query.filter(models.Content.content_type == content_type)
    if age_group:
        query = query.filter(models.Content.age_group == age_group)
    
    return query.offset(skip).limit(limit).all()


def create_content(db: Session, content: ContentCreate) -> models.Content:
    """Create new content"""
    db_content = models.Content(**content.model_dump())
    db.add(db_content)
    db.commit()
    db.refresh(db_content)
    return db_content


def update_content(db: Session, content_id: int, content_update: ContentUpdate) -> Optional[models.Content]:
    """Update content"""
    db_content = db.query(models.Content).filter(models.Content.id == content_id).first()
    if db_content:
        update_data = content_update.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_content, field, value)
        db.commit()
        db.refresh(db_content)
    return db_content


def delete_content(db: Session, content_id: int) -> bool:
    """Delete content (soft delete)"""
    db_content = db.query(models.Content).filter(models.Content.id == content_id).first()
    if db_content:
        db_content.is_active = False
        db.commit()
        return True
    return False


# User Progress CRUD operations
def get_user_progress(db: Session, user_id: int, content_id: int) -> Optional[models.UserProgress]:
    """Get user progress for specific content"""
    return db.query(models.UserProgress).filter(
        and_(models.UserProgress.user_id == user_id, 
             models.UserProgress.content_id == content_id)
    ).first()


def get_user_all_progress(db: Session, user_id: int) -> List[models.UserProgress]:
    """Get all progress for a user"""
    return db.query(models.UserProgress).filter(models.UserProgress.user_id == user_id).all()


def create_or_update_progress(db: Session, progress: UserProgressCreate) -> models.UserProgress:
    """Create or update user progress"""
    db_progress = get_user_progress(db, progress.user_id, progress.content_id)
    
    if db_progress:
        # Update existing progress
        for field, value in progress.model_dump().items():
            if field not in ['user_id', 'content_id'] and value is not None:
                setattr(db_progress, field, value)
    else:
        # Create new progress
        db_progress = models.UserProgress(**progress.model_dump())
        db.add(db_progress)
    
    db.commit()
    db.refresh(db_progress)
    return db_progress


# Achievement CRUD operations
def get_achievement(db: Session, achievement_id: int) -> Optional[models.Achievement]:
    """Get achievement by ID"""
    return db.query(models.Achievement).filter(models.Achievement.id == achievement_id).first()


def get_achievements(db: Session, skip: int = 0, limit: int = 100) -> List[models.Achievement]:
    """Get achievements"""
    return db.query(models.Achievement).filter(models.Achievement.is_active == True).offset(skip).limit(limit).all()


def create_achievement(db: Session, achievement: AchievementCreate) -> models.Achievement:
    """Create new achievement"""
    db_achievement = models.Achievement(**achievement.model_dump())
    db.add(db_achievement)
    db.commit()
    db.refresh(db_achievement)
    return db_achievement


def get_user_achievements(db: Session, user_id: int) -> List[models.UserAchievement]:
    """Get user achievements"""
    return db.query(models.UserAchievement).filter(models.UserAchievement.user_id == user_id).all()


def award_achievement(db: Session, user_id: int, achievement_id: int) -> Optional[models.UserAchievement]:
    """Award achievement to user"""
    # Check if user already has this achievement
    existing = db.query(models.UserAchievement).filter(
        and_(models.UserAchievement.user_id == user_id,
             models.UserAchievement.achievement_id == achievement_id)
    ).first()
    
    if existing:
        return existing
    
    # Award new achievement
    db_user_achievement = models.UserAchievement(
        user_id=user_id,
        achievement_id=achievement_id
    )
    db.add(db_user_achievement)
    db.commit()
    db.refresh(db_user_achievement)
    return db_user_achievement
