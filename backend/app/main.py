# File: backend/app/main.py

from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
import uvicorn
from datetime import datetime, timedelta
from typing import Optional, List
import redis.asyncio as redis
from contextlib import asynccontextmanager

from .database import init_db, close_db, get_async_db
from .models import User, UserPoints
from .routers import auth, parent, task, lesson, notification, chat_message
from .core.config import settings
from .services.ai_service import AIService


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Handles application startup and shutdown events.
    """
    # --- Startup Logic ---
    print("INFO:     Application startup...")
    
    # Initialize Database
    await init_db()
    
    # Initialize AI Service
    app.state.ai_service = AIService()
    
    # Initialize Redis Connection using REDIS_URL from settings
    try:
        # Use redis.asyncio and connect via the URL for async compatibility
        app.state.redis_client = await redis.from_url(
            settings.REDIS_URL,
            encoding="utf-8",
            decode_responses=True
        )
        # Asynchronously ping to test the connection
        await app.state.redis_client.ping()
        print("INFO:     Successfully connected to Redis.")
    except Exception as e:
        print(f"WARNING:  Redis connection failed: {e}. Continuing without Redis.")
        app.state.redis_client = None
    
    yield
    
    # --- Shutdown Logic ---
    print("INFO:     Application shutdown...")
    if hasattr(app.state, 'redis_client') and app.state.redis_client:
        await app.state.redis_client.close()
        print("INFO:     Redis connection closed.")
    await close_db()


# --- FastAPI App Initialization ---
app = FastAPI(
    title=settings.APP_NAME,
    description="Backend API for AI-powered educational app for children",
    version=settings.VERSION,
    lifespan=lifespan
)

# CORS middleware to allow cross-origin requests
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_HOSTS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API routers
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(parent.router, prefix="/api/parent", tags=["Parent"])
app.include_router(task.router, prefix="/api/tasks", tags=["Tasks"])
app.include_router(lesson.router, prefix="/api", tags=["Lessons"])
app.include_router(notification.router, prefix="/api/notifications", tags=["Notifications"])
app.include_router(chat_message.router, prefix="/api/chat_messages", tags=["ChatMessages"])


# --- Root and Health Check Endpoints ---
@app.get("/")
async def root():
    return {
        "message": f"Welcome to {settings.APP_NAME} API",
        "version": settings.VERSION,
        "status": "active"
    }

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "database_status": "connected", # Simplified for now
        "redis_status": "connected" if app.state.redis_client else "disconnected",
        "ai_service_status": "active"
    }

# --- Mock API Endpoints ---
@app.get("/api/dashboard/student/{user_id}")
async def get_student_dashboard(user_id: int, db: AsyncSession = Depends(get_async_db)):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    
    points_result = await db.execute(select(UserPoints).where(UserPoints.user_id == user_id))
    points = points_result.scalar_one_or_none()
    
    if not points:
        points = UserPoints(user_id=user_id) # Create default points if none exist
        db.add(points)
        await db.commit()
        await db.refresh(points)
    
    return {
        "user": {
            "id": user.id, "username": user.username, "full_name": user.full_name,
            "age": user.age, "grade": user.grade, "avatar_url": user.avatar_url
        },
        "points": {
            "knowledge_gems": points.knowledge_gems, "word_coins": points.word_coins,
            "imagination_sparks": points.imagination_sparks, "total_points": points.total_points,
            "current_streak": points.current_streak, "longest_streak": points.longest_streak,
            "last_activity_date": points.last_activity_date.isoformat() if points.last_activity_date else None
        },
        "recent_achievements": [{"id": 1, "name": "First Steps", "description": "Completed your first lesson!", "badge_icon": "🏆", "earned_at": "2024-01-10T09:00:00Z"}],
        "recommended_content": [
            {"id": 1, "title": "Fun with Numbers", "subject": "Math", "grade_level": user.grade or 1, "points_reward": 15, "estimated_duration": 10},
            {"id": 2, "title": "Letter Adventures", "subject": "English", "grade_level": user.grade or 1, "points_reward": 10, "estimated_duration": 8}
        ],
        "in_progress_content": []
    }

@app.get("/api/content/lessons")
async def get_lessons(grade_level: Optional[int] = None, subject: Optional[str] = None):
    # Mock data, to be replaced with database queries
    lessons = [
        {"id": 1, "title": "Numbers 1-10", "subject": "Math", "grade_level": 1, "difficulty_level": 1, "points_reward": 10, "estimated_duration": 5},
        {"id": 2, "title": "Alphabet Fun", "subject": "English", "grade_level": 1, "difficulty_level": 1, "points_reward": 10, "estimated_duration": 8}
    ]
    if grade_level:
        lessons = [l for l in lessons if l["grade_level"] == grade_level]
    if subject:
        lessons = [l for l in lessons if l["subject"].lower() == subject.lower()]
    return lessons

@app.get("/api/content/achievements")
async def get_achievements():
    # Mock data for achievements. In the future, this will come from the database.
    achievements = [
        {
            "id": 1,
            "name": "First Steps",
            "description": "Completed your first lesson!",
            "badge_icon": "🏆",
            "earned_at": "2024-01-10T09:00:00Z"
        },
        {
            "id": 2,
            "name": "Bookworm",
            "description": "Read 5 stories.",
            "badge_icon": "🐛",
            "earned_at": None # This achievement has not been earned yet
        },
        {
            "id": 3,
            "name": "Quiz Master",
            "description": "Scored 100% on a quiz.",
            "badge_icon": "🎯",
            "earned_at": "2024-02-15T11:30:00Z"
        }
    ]
    return achievements

@app.post("/api/progress/update")
async def update_progress(content_id: int, completion_percentage: float, time_spent: int, current_user: User = Depends(auth.get_current_active_user), db: AsyncSession = Depends(get_async_db)):
    # This endpoint will update the UserProgress table in a real implementation
    return {"message": "Progress updated successfully", "user": current_user.username, "content_id": content_id}

# --- Uvicorn Runner ---
if __name__ == "__main__":
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )
