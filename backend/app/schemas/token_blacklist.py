from pydantic import BaseModel
from datetime import datetime

class TokenBlacklistBase(BaseModel):
    jti: str

class TokenBlacklistOut(TokenBlacklistBase):
    id: int
    created_at: datetime

    class Config:
        orm_mode = True
