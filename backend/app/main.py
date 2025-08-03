# File: backend/app/main.py

from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
import uvicorn
import os
from datetime import datetime, timedelta
from typing import Optional
import redis
from contextlib import asynccontextmanager

from .database import init_db, close_db, get_async_db
from .models import User, UserPoints
from .routers import auth
from .core.config import settings
from .core.security import create_access_token
from .services.ai_service import AIService

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    # Initialize database
    await init_db()
    
    # Initialize AI service
    ai_service = AIService()
    app.state.ai_service = ai_service
    
    # Initialize Redis (optional - will work without Redis)
    try:
        app.state.redis_client = redis.Redis(
            host=settings.REDIS_HOST,
            port=settings.REDIS_PORT,
            decode_responses=True
        )
        # Test connection
        app.state.redis_client.ping()
    except Exception as e:
        print(f"Redis connection failed: {e}. Continuing without Redis.")
        app.state.redis_client = None
    
    yield
    
    # Shutdown
    if hasattr(app.state, 'redis_client') and app.state.redis_client:
        app.state.redis_client.close()
    await close_db()

app = FastAPI(
    title="AI Literacy App API",
    description="Backend API for AI-powered educational app for children",
    version="1.0.0",
    lifespan=lifespan
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["authentication"])

@app.get("/")
async def root():
    return {
        "message": "Welcome to AI Literacy App API",
        "version": "1.0.0",
        "status": "active",
        "database": "SQLite"
    }

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "database": "SQLite - connected",
        "ai_service": "active"
    }

# Mock endpoint for dashboard data with SQLite
@app.get("/api/dashboard/student/{user_id}")
async def get_student_dashboard(user_id: int, db: AsyncSession = Depends(get_async_db)):
    # Get user from database
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Get user points
    points_result = await db.execute(select(UserPoints).where(UserPoints.user_id == user_id))
    points = points_result.scalar_one_or_none()
    
    if not points:
        # Create default points if they don't exist
        points = UserPoints(user_id=user_id)
        db.add(points)
        await db.commit()
        await db.refresh(points)
    
    return {
        "user": {
            "id": user.id,
            "username": user.username,
            "full_name": user.full_name,
            "age": user.age,
            "grade": user.grade,
            "avatar_url": user.avatar_url
        },
        "points": {
            "knowledge_gems": points.knowledge_gems,
            "word_coins": points.word_coins,
            "imagination_sparks": points.imagination_sparks,
            "total_points": points.total_points,
            "current_streak": points.current_streak,
            "longest_streak": points.longest_streak,
            "last_activity_date": points.last_activity_date.isoformat() if points.last_activity_date else None
        },
        "recent_achievements": [
            {
                "id": 1,
                "name": "First Steps",
                "description": "Completed your first lesson!",
                "badge_icon": "🏆",
                "earned_at": "2024-01-10T09:00:00Z"
            }
        ],
        "recommended_content": [
            {
                "id": 1,
                "title": "Fun with Numbers",
                "subject": "Math",
                "grade_level": user.grade or 1,
                "points_reward": 15,
                "estimated_duration": 10
            },
            {
                "id": 2,
                "title": "Letter Adventures",
                "subject": "English",
                "grade_level": user.grade or 1,
                "points_reward": 10,
                "estimated_duration": 8
            }
        ],
        "in_progress_content": []
    }

# Content endpoints
@app.get("/api/content/lessons")
async def get_lessons(grade_level: Optional[int] = None, subject: Optional[str] = None):
    """Get available lessons"""
    # Mock data - in real implementation, query from database
    lessons = [
        {
            "id": 1,
            "title": "Numbers 1-10",
            "subject": "Math",
            "grade_level": 1,
            "difficulty_level": 1,
            "points_reward": 10,
            "estimated_duration": 5
        },
        {
            "id": 2,
            "title": "Alphabet Fun",
            "subject": "English",
            "grade_level": 1,
            "difficulty_level": 1,
            "points_reward": 10,
            "estimated_duration": 8
        }
    ]
    
    # Filter by grade level and subject if provided
    if grade_level:
        lessons = [l for l in lessons if l["grade_level"] == grade_level]
    if subject:
        lessons = [l for l in lessons if l["subject"].lower() == subject.lower()]
    
    return lessons

@app.post("/api/progress/update")
async def update_progress(
    content_id: int,
    completion_percentage: float,
    time_spent: int,
    current_user = Depends(auth.get_current_active_user),
    db: AsyncSession = Depends(get_async_db)
):
    """Update user progress for content"""
    # In real implementation, update UserProgress table
    return {
        "message": "Progress updated successfully",
        "content_id": content_id,
        "completion_percentage": completion_percentage,
        "time_spent": time_spent
    }

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )