from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from .. import crud, schemas
from ..database import get_db
from ..services.auth import get_current_active_user

router = APIRouter()


@router.get("/me", response_model=schemas.UserResponse)
async def read_users_me(current_user: schemas.UserResponse = Depends(get_current_active_user)):
    """Get current user profile"""
    return current_user


@router.put("/me", response_model=schemas.UserResponse)
async def update_users_me(
    user_update: schemas.UserUpdate,
    current_user: schemas.UserResponse = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Update current user profile"""
    updated_user = crud.update_user(db, current_user.id, user_update)
    if not updated_user:
        raise HTTPException(status_code=404, detail="User not found")
    return updated_user


@router.get("/", response_model=List[schemas.UserResponse])
async def read_users(
    skip: int = 0, 
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Get all users (admin only - implement proper authorization)"""
    users = crud.get_users(db, skip=skip, limit=limit)
    return users


@router.get("/{user_id}", response_model=schemas.UserResponse)
async def read_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Get user by ID"""
    db_user = crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user


@router.get("/{user_id}/progress", response_model=List[schemas.UserProgressResponse])
async def read_user_progress(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Get user progress"""
    # Check if user is accessing their own progress or has admin rights
    if current_user.id != user_id:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    progress = crud.get_user_all_progress(db, user_id=user_id)
    return progress


@router.post("/{user_id}/progress", response_model=schemas.UserProgressResponse)
async def create_user_progress(
    user_id: int,
    progress: schemas.UserProgressCreate,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Create or update user progress"""
    # Check if user is updating their own progress
    if current_user.id != user_id or progress.user_id != user_id:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    return crud.create_or_update_progress(db, progress)
