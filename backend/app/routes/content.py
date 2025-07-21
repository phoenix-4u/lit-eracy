from fastapi import APIRouter, Depends
from ..services.content import get_lessons

router = APIRouter()

@router.get("/lessons")
async def lessons(user_id: int = Depends()):
    return await get_lessons(user_id)