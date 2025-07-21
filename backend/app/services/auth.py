from sqlalchemy.orm import Session
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from datetime import timedelta
from typing import Optional

from .. import crud, schemas
from ..database import get_db
from ..utils.auth import decode_access_token, create_access_token


# Security scheme
security = HTTPBearer()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> schemas.UserResponse:
    """Get current authenticated user"""
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        token = credentials.credentials
        payload = decode_access_token(token)
        if payload is None:
            raise credentials_exception
            
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
            
    except Exception:
        raise credentials_exception
    
    user = crud.get_user_by_email(db, email=email)
    if user is None:
        raise credentials_exception
    
    return schemas.UserResponse.model_validate(user)


async def get_current_active_user(
    current_user: schemas.UserResponse = Depends(get_current_user)
) -> schemas.UserResponse:
    """Get current active user"""
    if not current_user.is_active:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user


def authenticate_user_service(db: Session, email: str, password: str) -> Optional[schemas.UserResponse]:
    """Authenticate user service"""
    user = crud.authenticate_user(db, email, password)
    if user:
        return schemas.UserResponse.model_validate(user)
    return None


def create_access_token_service(email: str) -> str:
    """Create access token for user"""
    access_token_expires = timedelta(minutes=30)
    access_token = create_access_token(
        data={"sub": email}, expires_delta=access_token_expires
    )
    return access_token
