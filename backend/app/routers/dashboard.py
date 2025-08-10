# backend/app/routers/dashboard.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select, func, desc
from sqlalchemy.ext.asyncio import AsyncSession
from datetime import datetime
from typing import List

from ..schemas.dashboard import StudentDashboard, PointsOut, LessonInfo
from ..models import UserPoints, UserProgress, Content  # adjust import paths as needed
from ..database import get_async_db
from .auth import get_current_active_user

router = APIRouter(tags=["Dashboard"])

@router.get("/student", response_model=StudentDashboard)
async def student_dashboard(
    current_user = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_async_db),
):
    if current_user.role != "student":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                            detail="Only students may access this dashboard")

    # 1) Fetch or initialize points
    qp = await db.execute(select(UserPoints).where(UserPoints.user_id == current_user.id))
    points: UserPoints = qp.scalar_one_or_none()
    if not points:
        points = UserPoints(user_id=current_user.id)
        db.add(points)
        await db.commit()
        await db.refresh(points)

    # 2) Fetch completed dates (newest first)
    pr = await db.execute(
        select(UserProgress.updated_at)
        .where(UserProgress.user_id == current_user.id, UserProgress.is_completed == True)
        .order_by(desc(UserProgress.updated_at))
    )
    dates = [row for row, in pr.all()]

    # 3) Compute streaks
    today = datetime.utcnow().date()
    current_streak = 0
    longest_streak = points.longest_streak or 0
    prev_date = None
    for ts in dates:
        d = ts.date()
        if prev_date is None:
            if (today - d).days <= 1:
                current_streak = 1
            prev_date = d
        else:
            if (prev_date - d).days == 1:
                current_streak += 1
                prev_date = d
            else:
                break
    longest_streak = max(longest_streak, current_streak)

    # 4) Count total lessons
    total_lessons = await db.scalar(select(func.count(Content.id)))

    # 5) Prepare lesson lists (mock or real queries)
    # Here you would fetch actual recent and recommended content from DB
    recent_lessons: List[LessonInfo] = []
    recommended: List[LessonInfo] = []

    return StudentDashboard(
        num_lessons=total_lessons,
        points=PointsOut(
            knowledge_gems=points.knowledge_gems,
            word_coins=points.word_coins,
            imagination_sparks=points.imagination_sparks,
            total_points=points.total_points,
            current_streak=current_streak,
            longest_streak=longest_streak,
            last_activity_date=prev_date.isoformat() if prev_date else None,
        ),
        recent_lessons=recent_lessons,
        recommended_content=recommended,
    )
