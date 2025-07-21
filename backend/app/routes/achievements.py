from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from .. import crud, schemas
from ..database import get_db
from ..services.auth import get_current_active_user

router = APIRouter()


@router.get("/", response_model=List[schemas.AchievementResponse])
async def read_achievements(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Get all achievements"""
    achievements = crud.get_achievements(db, skip=skip, limit=limit)
    return achievements


@router.get("/{achievement_id}", response_model=schemas.AchievementResponse)
async def read_achievement(
    achievement_id: int,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Get achievement by ID"""
    achievement = crud.get_achievement(db, achievement_id=achievement_id)
    if achievement is None:
        raise HTTPException(status_code=404, detail="Achievement not found")
    return achievement


@router.post("/", response_model=schemas.AchievementResponse)
async def create_achievement(
    achievement: schemas.AchievementCreate,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Create new achievement (admin only - implement proper authorization)"""
    return crud.create_achievement(db=db, achievement=achievement)


@router.get("/users/{user_id}", response_model=List[schemas.UserAchievementResponse])
async def read_user_achievements(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Get user achievements"""
    # Check if user is accessing their own achievements
    if current_user.id != user_id:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    achievements = crud.get_user_achievements(db, user_id=user_id)
    return achievements


@router.post("/users/{user_id}/award/{achievement_id}", response_model=schemas.UserAchievementResponse)
async def award_user_achievement(
    user_id: int,
    achievement_id: int,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Award achievement to user (admin only - implement proper authorization)"""
    user_achievement = crud.award_achievement(db, user_id=user_id, achievement_id=achievement_id)
    if not user_achievement:
        raise HTTPException(status_code=400, detail="Could not award achievement")
    return user_achievement
