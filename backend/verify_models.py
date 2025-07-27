from app.database import Base
from app import models
from sqlalchemy import inspect

def verify_model_definitions():
    print("=== Verifying Model Definitions ===")
    
    # Check what models are registered with Base
    print(f"Models registered with Base.registry: {len(Base.registry.mappers)}")
    
    for mapper in Base.registry.mappers:
        cls = mapper.class_
        print(f"\nModel: {cls.__name__}")
        print(f"Table name: {cls.__tablename__}")
        
        if hasattr(cls, '__table__'):
            print("Columns defined in model:")
            for column in cls.__table__.columns:
                print(f"  - {column.name}: {column.type}")
    
    # Check User model specifically
    if hasattr(models, 'User'):
        print(f"\n=== User Model Details ===")
        user_columns = [column.name for column in models.User.__table__.columns]
        print(f"User model columns: {user_columns}")
        
        expected_columns = ['id', 'email', 'username', 'hashed_password', 'full_name', 'age', 'is_active', 'created_at', 'updated_at']
        missing_columns = [col for col in expected_columns if col not in user_columns]
        
        if missing_columns:
            print(f"❌ MISSING COLUMNS: {missing_columns}")
        else:
            print("✅ All expected columns are present in model definition")

if __name__ == "__main__":
    verify_model_definitions()
