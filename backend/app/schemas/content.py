from pydantic import BaseModel
from typing import Optional

class ContentBase(BaseModel):
    title: str
    content_type: str
    difficulty_level: int
    is_active: bool = True

class ContentCreate(ContentBase):
    pass

class ContentUpdate(BaseModel):
    title: Optional[str] = None
    content_type: Optional[str] = None
    difficulty_level: Optional[int] = None
    is_active: Optional[bool] = None

class ContentResponse(ContentBase):
    id: int

    class Config:
        from_attributes = True