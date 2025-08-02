# File: backend/app/core/config.py

import os
from typing import Optional
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # App settings
    APP_NAME: str = "AI Literacy App"
    VERSION: str = "1.0.0"
    DEBUG: bool = True
    
    # Database
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./ai_literacy_app.db")
    
    # Redis
    REDIS_HOST: str = os.getenv("REDIS_HOST", "localhost")
    REDIS_PORT: int = int(os.getenv("REDIS_PORT", "6379"))
    
    # Security
    SECRET_KEY: str = os.getenv("SECRET_KEY", "your-super-secret-key-change-in-production")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days
    
    # AI Settings
    AI_MODEL_PATH: str = os.getenv("AI_MODEL_PATH", "./models/gemma_2b_quantized.tflite")
    AI_MAX_TOKENS: int = 512
    AI_TEMPERATURE: float = 0.7
    
    # File uploads
    UPLOAD_DIR: str = "./uploads"
    MAX_FILE_SIZE: int = 10 * 1024 * 1024  # 10MB
    
    # Email settings (for notifications)
    SMTP_SERVER: Optional[str] = os.getenv("SMTP_SERVER")
    SMTP_PORT: Optional[int] = int(os.getenv("SMTP_PORT", "587")) if os.getenv("SMTP_PORT") else None
    SMTP_USERNAME: Optional[str] = os.getenv("SMTP_USERNAME")
    SMTP_PASSWORD: Optional[str] = os.getenv("SMTP_PASSWORD")
    
    # CORS settings
    ALLOWED_HOSTS: list = ["*"]  # In production, specify exact hosts
    
    # Parental control settings
    DEFAULT_DAILY_LIMIT_MINUTES: int = 60
    DEFAULT_BREAK_REMINDER_MINUTES: int = 15
    
    class Config:
        env_file = ".env"

settings = Settings()