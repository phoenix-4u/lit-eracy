from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordRequestForm
from ..services.auth import login_user
from ..services.token import blacklist_token
from ..utils.dependencies import oauth2_scheme
from jose import jwt

router = APIRouter()

@router.post("/token", response_model=dict)
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends()):
    token_data = await login_user({"username": form_data.username, "password": form_data.password})
    return token_data

@router.post("/logout")
async def logout(token: str = Depends(oauth2_scheme)):
    try:
        jti = jwt.get_unverified_header(token).get("jti")
        blacklist_token(jti)
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid token")
    return {"msg": "Successfully logged out"}
