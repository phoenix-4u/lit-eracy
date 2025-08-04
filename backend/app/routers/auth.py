# File: backend/app/routers/auth.py

from fastapi import APIRouter, Depends, HTTPException, status, Request
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from datetime import timedelta
from typing import Optional

from ..database import get_async_db
from ..models import User, UserPoints
from ..schemas import Token, UserCreate, UserResponse, UserLogin
from ..core.config import settings
from ..core.security import verify_password, get_password_hash, create_access_token
from jose import JWTError, jwt

router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="api/auth/token")

async def get_current_user(token: str = Depends(oauth2_scheme), db: AsyncSession = Depends(get_async_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    result = await db.execute(select(User).where(User.username == username))
    user = result.scalar_one_or_none()
    if user is None:
        raise credentials_exception
    return user

async def get_current_active_user(current_user: User = Depends(get_current_user)):
    if not current_user.is_active:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user

# Updated authenticate_user function to support both email and username
async def authenticate_user(db: AsyncSession, email_or_username: str, password: str):
    # Try to find user by email first, then by username
    result = await db.execute(
        select(User).where(
            (User.email == email_or_username) | (User.username == email_or_username)
        )
    )
    user = result.scalar_one_or_none()
    if not user:
        return False
    if not verify_password(password, user.hashed_password):
        return False
    return user

@router.post("/register", response_model=UserResponse)
async def register(user_data: UserCreate, db: AsyncSession = Depends(get_async_db)):
    # Check if user already exists
    result = await db.execute(
        select(User).where(
            (User.username == user_data.username) | (User.email == user_data.email)
        )
    )
    existing_user = result.scalar_one_or_none()
    
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username or email already registered"
        )
    
    # Create new user
    hashed_password = get_password_hash(user_data.password)
    
    db_user = User(
        username=user_data.username,
        email=user_data.email,
        hashed_password=hashed_password,
        full_name=user_data.full_name,
        age=user_data.age,
        grade=user_data.grade,
        role=user_data.role,
        parent_email=user_data.parent_email,
        avatar_url=user_data.avatar_url
    )
    
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    
    # Initialize user points
    user_points = UserPoints(user_id=db_user.id)
    db.add(user_points)
    await db.commit()
    
    return UserResponse.model_validate(db_user)

@router.post("/token", response_model=Token)
async def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: AsyncSession = Depends(get_async_db)
):
    user = await authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": UserResponse.model_validate(user)
    }

@router.post("/login", response_model=Token)
async def login( request: Request, user_credentials: UserLogin, db: AsyncSession = Depends(get_async_db)):
    # Changed from user_credentials.username to user_credentials.email

    # --- 3. ADD THESE PRINT STATEMENTS FOR DEBUGGING ---
    print("===================== LOGIN REQUEST DIAGNOSTICS =====================")
    print(f"Request Headers: {request.headers}")
    try:
        # FIX: Use request.json() because the Content-Type is application/json
        json_body = await request.json()
        print(f"Request JSON Body: {json_body}")
    except Exception as e:
        # This is a fallback in case the body is not valid JSON for some reason
        raw_body = await request.body()
        print(f"Could not parse JSON body. Raw Body: {raw_body}")
        print(f"Error parsing JSON: {e}")
    print("==================================================================")
       # --- END OF DEBUGGING PRINTS ---

    user = await authenticate_user(db, user_credentials.email, user_credentials.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )
    
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": UserResponse.model_validate(user)
    }

@router.get("/me", response_model=UserResponse)
async def read_users_me(current_user: User = Depends(get_current_active_user)):
    return UserResponse.model_validate(current_user)

@router.post("/refresh-token", response_model=Token)
async def refresh_access_token(current_user: User = Depends(get_current_active_user)):
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": current_user.username}, expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": UserResponse.model_validate(current_user)
    }
