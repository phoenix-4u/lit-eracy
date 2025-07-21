from ..models.user import User
from ..database import SessionLocal
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_user_by_username(username: str):
    db = SessionLocal()
    user = db.query(User).filter(User.username == username).first()
    db.close()
    return user

def create_user(username: str, password: str):
    db = SessionLocal()
    hashed = pwd_context.hash(password)
    new_user = User(username=username, hashed_password=hashed)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    db.close()
    return new_user
