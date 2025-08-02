# File: backend/app/main.py

from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy import create_engine
import uvicorn
import os
from datetime import datetime, timedelta
from typing import Optional
import redis
from contextlib import asynccontextmanager

from .database import engine, get_db
from .models import Base
from .routers import auth
from .core.config import settings
from .core.security import create_access_token
from .services.ai_service import AIService

# Create tables
Base.metadata.create_all(bind=engine)

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
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
        "status": "active"
    }

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "database": "connected",
        "ai_service": "active"
    }

# Mock endpoint for dashboard data
@app.get("/api/dashboard/student/{user_id}")
async def get_student_dashboard(user_id: int, db: Session = Depends(get_db)):
    # Mock dashboard data for testing
    return {
        "user": {
            "id": user_id,
            "username": "student1",
            "full_name": "Alex Johnson",
            "age": 8,
            "grade": 2,
            "avatar_url": None
        },
        "points": {
            "knowledge_gems": 150,
            "word_coins": 75,
            "imagination_sparks": 30,
            "total_points": 255,
            "current_streak": 5,
            "longest_streak": 12,
            "last_activity_date": "2024-01-15T10:30:00Z"
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
                "grade_level": 2,
                "points_reward": 15,
                "estimated_duration": 10
            }
        ]
    }

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )