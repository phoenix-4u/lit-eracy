# File: backend/app/database.py

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
import os
import asyncio

# Database URL - SQLite for development and production
DATABASE_URL = os.getenv(
    "DATABASE_URL", 
    "sqlite:///./data/literacy_database.db"
)

# Async SQLite URL
ASYNC_DATABASE_URL = os.getenv(
    "ASYNC_DATABASE_URL",
    "sqlite+aiosqlite:///./data/literacy_database.db"
)

# Create sync engine for migrations and admin tasks
sync_engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False},  # Only for SQLite
    echo=False  # Set to True for SQL debugging
)

# Create async engine for FastAPI
async_engine = create_async_engine(
    ASYNC_DATABASE_URL,
    echo=False,  # Set to True for SQL debugging
    future=True
)

# Create session factories
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=sync_engine)
AsyncSessionLocal = async_sessionmaker(
    async_engine,
    class_=AsyncSession,
    expire_on_commit=False
)

# Base class for models
Base = declarative_base()

# Dependency to get database session (sync)
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Dependency to get async database session
async def get_async_db():
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()

# Initialize database
async def init_db():
    """Initialize database tables"""
    async with async_engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

# Close database connections
async def close_db():
    """Close database connections"""
    await async_engine.dispose()