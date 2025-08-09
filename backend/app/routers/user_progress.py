# backend/app/routers/user_progress.py

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from ..schemas.user_progress import UserProgressCreate, UserProgressResponse
from ..models.user_progress import UserProgress
from ..database import get_async_db
from ..routers.auth import get_current_active_user

router = APIRouter(prefix="/api/progress", tags=["Progress"])

@router.post("/update", response_model=UserProgressResponse)
async def update_progress(
    progress: UserProgressCreate,
    current_user=Depends(get_current_active_user),
    db: AsyncSession = Depends(get_async_db),
):
    # Map schema to model
    prog = await db.get(
        UserProgress,
        {"user_id": current_user.id, "content_id": progress.content_id},
    )
    if not prog:
        prog = UserProgress(
            user_id=current_user.id,
            content_id=progress.content_id,
            is_completed=progress.is_completed,
            time_spent=progress.time_spent,
            score=int(progress.completion_percentage * 100),
        )
        db.add(prog)
    else:
        prog.is_completed = progress.is_completed
        prog.time_spent = progress.time_spent
        prog.score = int(progress.completion_percentage * 100)

    await db.commit()
    await db.refresh(prog)
    return prog
