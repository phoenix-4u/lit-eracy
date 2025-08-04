# File: backend/app/core/config.py (Corrected)

from typing import List, Optional
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    """
    Application settings, loaded from environment variables or a .env file.
    Default values are provided for local development and will be overridden
    by any values found in the .env file or the system environment.
    """
    
    # Configure Pydantic to load from a .env file
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,  # e.g., DATABASE_URL is the same as database_url
    )

    # App settings
    APP_NAME: str = "Lit-eracy"
    VERSION: str = "1.0.0"
    DEBUG: bool = True
    
    # Database URL
    DATABASE_URL: str = "sqlite+aiosqlite:///./ai_literacy_app.db"
    
    # Redis URL (To match the value from your error log)
    REDIS_URL: str = "redis://localhost:6379/0"
    
    # Security
    SECRET_KEY: str = "your-super-secret-key-change-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days
    
    # AI Settings
    AI_MODEL_PATH: str = "./models/gemma_2b_quantized.tflite"
    AI_MAX_TOKENS: int = 512
    AI_TEMPERATURE: float = 0.7
    
    # File uploads
    UPLOAD_DIR: str = "./uploads"
    MAX_FILE_SIZE: int = 10 * 1024 * 1024  # 10MB
    
    # Email settings (for notifications)
    SMTP_SERVER: Optional[str] = None
    SMTP_PORT: Optional[int] = 587
    SMTP_USERNAME: Optional[str] = None
    SMTP_PASSWORD: Optional[str] = None
    
    # CORS settings
    ALLOWED_HOSTS: List[str] = ["*"]
    
    # Parental control settings
    DEFAULT_DAILY_LIMIT_MINUTES: int = 60
    DEFAULT_BREAK_REMINDER_MINUTES: int = 15

# Instantiate the settings. Pydantic handles the loading.
settings = Settings()
