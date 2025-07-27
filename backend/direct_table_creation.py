from sqlalchemy import create_engine, Column, Integer, String, Boolean, DateTime, ForeignKey, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from app.database import SQLALCHEMY_DATABASE_URL  # ✅ CORRECT IMPORT

# Create completely fresh Base and models
FreshBase = declarative_base()

class User(FreshBase):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    username = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String)
    age = Column(Integer)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

class Content(FreshBase):
    __tablename__ = "contents"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(Text)
    content_type = Column(String, nullable=False)
    difficulty_level = Column(Integer, default=1)
    age_group = Column(String)
    content_data = Column(Text)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

# Add other models as needed...

def create_fresh_schema():
    engine = create_engine(SQLALCHEMY_DATABASE_URL)  # ✅ USE CORRECT VARIABLE
    
    print("Dropping all existing tables...")
    FreshBase.metadata.drop_all(bind=engine)
    
    print("Creating fresh schema...")
    FreshBase.metadata.create_all(bind=engine)
    
    print("✅ Fresh schema created successfully!")
    
    # Verify
    from sqlalchemy import inspect
    inspector = inspect(engine)
    columns = inspector.get_columns('users')
    print(f"\nCreated 'users' table with {len(columns)} columns:")
    for column in columns:
        print(f"  ✅ {column['name']}: {column['type']}")

if __name__ == "__main__":
    create_fresh_schema()
