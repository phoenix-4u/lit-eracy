from typing import Optional

from pydantic import BaseModel

class UserResponse(BaseModel):
    id: int
    email: str
    username: Optional[str] = None
    full_name: Optional[str] = None
    age: Optional[int] = None
    is_active: bool = True

    class Config:
        from_attributes = True

class UserBase(BaseModel):
    email: str


class UserCreate(UserBase):
    password: str


class UserUpdate(BaseModel):
    email: str = None
    password: str = None
    full_name: str = None
    age: int = None

class UserLogin(BaseModel):
    email: str
    password: str

class User(UserBase):
    id: int
    is_active: bool

    class Config:
        from_attributes = True