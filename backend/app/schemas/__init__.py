# File: backend/app/schemas/__init__.py

from .user import User, UserCreate, UserUpdate, UserResponse, UserLogin
from .token import Token
from .lesson import LessonOut, LessonBase
from .task import TaskOut, TaskCreate, TaskBase
from .achievement import AchievementResponse, AchievementCreate, AchievementBase
from .user_progress import UserProgressResponse, UserProgressCreate
from .content import ContentResponse, ContentCreate, ContentUpdate
from .user_achievement import UserAchievementResponse
from .parent import (
    ParentDashboardResponse, LinkChildRequest, LinkChildResponse,
    ChildDashboardData
)
from .notification import NotificationCreate, NotificationOut
from .chat_message import ChatMessageCreate, ChatMessageOut

__all__ = [
    # User schemas
    "User", "UserCreate", "UserUpdate", "UserResponse", "UserLogin",
    # Token schemas
    "Token",
    # Lesson schemas
    "LessonOut", "LessonBase",
    # Task schemas
    "TaskOut", "TaskCreate", "TaskBase",
    # Achievement schemas
    "AchievementResponse", "AchievementCreate", "AchievementBase",
    # User progress schemas
    "UserProgressResponse", "UserProgressCreate",
    # Content schemas
    "ContentResponse", "ContentCreate", "ContentUpdate",
    # User achievement schemas
    "UserAchievementResponse",
    # Parent schemas
    "ParentDashboardResponse", "LinkChildRequest", "LinkChildResponse",
    "ChildDashboardData",
    # Notification schemas
    "NotificationCreate", "NotificationOut",
    # Chat message schemas
    "ChatMessageCreate", "ChatMessageOut"
]