
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from .. import crud, schemas, models  
from ..database import get_db
from ..services.auth import get_current_active_user


router = APIRouter()

# ✅ Specific endpoints MUST come before generic path parameters
@router.get("/lessons", response_model=List[schemas.ContentResponse])
async def get_lessons(
    grade: int = Query(..., description="Grade level (1-12)"),
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Get lessons filtered by grade level"""
    try:
        # Query lessons by grade
        lessons = db.query(models.Content).filter(
            models.Content.content_type == "lesson",
            models.Content.difficulty_level == grade,
            models.Content.is_active == True
        ).all()
        
        # ✅ Handle empty results without raising exception
        if not lessons:
            # Return empty list instead of raising exception
            return []
            
        return lessons
        
    except Exception as e:
        # ✅ Only catch actual database/system errors
        print(f"Database error in get_lessons: {e}")
        raise HTTPException(
            status_code=500, 
            detail="Internal server error while fetching lessons"
        )

@router.post("/complete_task")
async def complete_task(
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Complete a task, award currency, and unlock content"""
    user = db.query(crud.models.User).filter_by(id=current_user.id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.currency += 10  # Award 10 Knowledge Gems
    db.commit()
    # Unlock content logic (simple: unlock first locked content)
    locked_content = db.query(crud.models.Content).filter_by(is_active=True).first()
    unlocked = None
    if locked_content:
        unlocked = locked_content.title
    return {"currency": user.currency, "unlocked_content": unlocked, "message": "Task completed!"}

@router.get("/", response_model=List[schemas.ContentResponse])
async def read_contents(
    skip: int = 0,
    limit: int = 100,
    content_type: Optional[str] = None,
    age_group: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Get all contents with filters"""
    contents = crud.get_contents(db, skip=skip, limit=limit, content_type=content_type, age_group=age_group)
    return contents


@router.get("/{content_id}", response_model=schemas.ContentResponse)
async def read_content(
    content_id: int,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Get content by ID"""
    content = crud.get_content(db, content_id=content_id)
    if content is None:
        raise HTTPException(status_code=404, detail="Content not found")
    return content


@router.post("/", response_model=schemas.ContentResponse)
async def create_content(
    content: schemas.ContentCreate,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Create new content (admin only - implement proper authorization)"""
    return crud.create_content(db=db, content=content)


@router.put("/{content_id}", response_model=schemas.ContentResponse)
async def update_content(
    content_id: int,
    content_update: schemas.ContentUpdate,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Update content (admin only - implement proper authorization)"""
    updated_content = crud.update_content(db, content_id, content_update)
    if not updated_content:
        raise HTTPException(status_code=404, detail="Content not found")
    return updated_content


@router.delete("/{content_id}")
async def delete_content(
    content_id: int,
    db: Session = Depends(get_db),
    current_user: schemas.UserResponse = Depends(get_current_active_user)
):
    """Delete content (admin only - implement proper authorization)"""
    success = crud.delete_content(db, content_id)
    if not success:
        raise HTTPException(status_code=404, detail="Content not found")
    return {"message": "Content deleted successfully"}
