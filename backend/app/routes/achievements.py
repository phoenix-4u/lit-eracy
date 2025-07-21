from fastapi import APIRouter, Depends
from ..services.achievement import get_achievements

router = APIRouter()

@router.get("/achievements")
async def achievements(user_id: int = Depends()):
    return await get_achievements(user_id)
