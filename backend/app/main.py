from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import uvicorn

from .database import engine
from .base import Base 
from .routes import auth, users, content, achievements, task


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Create database tables
    Base.metadata.create_all(bind=engine)
    yield
    # Cleanup code here if needed


app = FastAPI(
    title="AI Literacy App API",
    description="Backend API for AI Literacy educational app",
    version="1.0.0",
    lifespan=lifespan
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure this for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(users.router, prefix="/api/users", tags=["users"])
app.include_router(content.router, prefix="/api/content", tags=["content"])
app.include_router(achievements.router, prefix="/api/achievements", tags=["achievements"])
app.include_router(task.router, prefix="/api", tags=["tasks"])


@app.get("/")
async def root():
    return {"message": "AI Literacy App API is running!"}


@app.get("/health")
async def health_check():
    return {"status": "healthy"}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
