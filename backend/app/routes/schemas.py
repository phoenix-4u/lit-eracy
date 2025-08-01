from fastapi import APIRouter, Depends
from ..schemas.user import UserOut, UserCreate
from ..schemas.lesson import LessonOut
from ..schemas.achievement import AchievementResponse

router = APIRouter()

# This file is just for centralizing schema imports; actual endpoints are in auth.py, content.py, achievements.py
