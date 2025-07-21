
from app.database import SessionLocal, engine
from app.models.user import User
from app.utils.security import get_password_hash

def create_user():
    db = SessionLocal()
    db_user = User(username="test@example.com", hashed_password=get_password_hash("password"))
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    db.close()
    print("User created successfully!")

if __name__ == "__main__":
    create_user()
