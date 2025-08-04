# File: backend/app/routers/parent.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from datetime import datetime, timedelta
from ..database import get_async_db
from ..models import (
    User, UserPoints, UserProgress, UserAchievement, ParentChild
)
from ..schemas.parent import (
    ParentDashboardResponse, LinkChildRequest, LinkChildResponse,
    ChildDashboardData, ChildSummary, ChildPoints, ChildProgress
)
from .auth import get_current_active_user

router = APIRouter()

@router.get("/dashboard", response_model=ParentDashboardResponse)
async def get_parent_dashboard(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_async_db)
):
    if current_user.role != "parent":
        raise HTTPException(status_code=403, detail="Only parents can access")

    # Fetch linked children
    result = await db.execute(
        select(ParentChild)
        .options(selectinload(ParentChild.child))
        .where(ParentChild.parent_id == current_user.id, ParentChild.is_active)
    )
    links = result.scalars().all()

    children_data, total_points, total_time = [], 0, 0
    for link in links:
        c = link.child
        # points
        pts = (await db.execute(select(UserPoints)
            .where(UserPoints.user_id == c.id))).scalar_one_or_none()
        # progress records
        recs = (await db.execute(select(UserProgress)
            .where(UserProgress.user_id == c.id))).scalars().all()
        tot_less = len(recs)
        comp_less = len([r for r in recs if r.is_completed])
        pct = (comp_less / tot_less * 100) if tot_less else 0
        now = datetime.utcnow()
        today = sum(r.time_spent for r in recs
                    if r.first_attempt_at and r.first_attempt_at.date() == now.date())//60
        week = sum(r.time_spent for r in recs
                   if r.first_attempt_at and r.first_attempt_at >= now - timedelta(days=7))//60
        # recent achievements
        achs = (await db.execute(select(UserAchievement)
            .where(UserAchievement.user_id == c.id)
            .order_by(UserAchievement.earned_at.desc())
            .limit(3))).scalars().all()

        child_data = ChildDashboardData(
            child=ChildSummary(
                id=c.id, username=c.username, full_name=c.full_name,
                age=c.age, grade=c.grade, avatar_url=c.avatar_url,
                last_activity=c.updated_at, is_active=c.is_active
            ),
            points=ChildPoints(
                knowledge_gems=pts.knowledge_gems if pts else 0,
                word_coins=pts.word_coins if pts else 0,
                imagination_sparks=pts.imagination_sparks if pts else 0,
                total_points=pts.total_points if pts else 0,
                current_streak=pts.current_streak if pts else 0,
                longest_streak=pts.longest_streak if pts else 0
            ),
            progress=ChildProgress(
                total_lessons=tot_less, completed_lessons=comp_less,
                completion_percentage=pct,
                time_spent_today=today, time_spent_week=week
            ),
            recent_achievements=[{
                "id": a.achievement_id, "earned_at": a.earned_at.isoformat()
            } for a in achs],
            recent_activities=[{
                "id": r.id, "content_id": r.content_id,
                "completed_at": r.completed_at.isoformat() if r.completed_at else None,
                "score": r.score
            } for r in recs if r.is_completed][-3:]
        )
        children_data.append(child_data)
        total_points += child_data.points.total_points
        total_time += child_data.progress.time_spent_week

    return ParentDashboardResponse(
        parent_info={
            "id": current_user.id,
            "full_name": current_user.full_name,
            "email": current_user.email,
            "children_count": len(children_data)
        },
        children=children_data,
        family_stats={
            "total_family_points": total_points,
            "total_weekly_time": total_time,
            "active_children": len([c for c in children_data if c.child.is_active])
        }
    )

@router.post("/link-child", response_model=LinkChildResponse)
async def link_child(
    req: LinkChildRequest,
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_async_db)
):
    if current_user.role != "parent":
        raise HTTPException(status_code=403, detail="Only parents can link")
    child = (await db.execute(
        select(User).where(User.email == req.child_email)
    )).scalar_one_or_none()
    if not child or child.role != "student":
        raise HTTPException(status_code=400, detail="Child not found or not student")
    exists = (await db.execute(
        select(ParentChild)
        .where(ParentChild.parent_id == current_user.id,
               ParentChild.child_id == child.id,
               ParentChild.is_active)
    )).scalar_one_or_none()
    if exists:
        return LinkChildResponse(False, "Already linked", None)
    pc = ParentChild(parent_id=current_user.id, child_id=child.id, is_active=True)
    db.add(pc); await db.commit()
    return LinkChildResponse(True, f"Linked {child.full_name}", child.id)

@router.get("/children")
async def get_children(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_async_db)
):
    if current_user.role != "parent":
        raise HTTPException(status_code=403, detail="Only parents can access")
    rows = (await db.execute(
        select(ParentChild)
        .options(selectinload(ParentChild.child))
        .where(ParentChild.parent_id == current_user.id, ParentChild.is_active)
    )).scalars().all()
    return {"children": [
        {
            "id": r.child.id,
            "username": r.child.username,
            "full_name": r.child.full_name,
            "age": r.child.age,
            "grade": r.child.grade,
            "linked_at": r.linked_at.isoformat()
        } for r in rows
    ]}
