from sqlalchemy import inspect, create_engine
from app.database import SQLALCHEMY_DATABASE_URL, Base
from app import models
import os

def debug_schema_mismatch():
    # Create engine directly
    if SQLALCHEMY_DATABASE_URL.startswith("sqlite"):
        engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
    else:
        engine = create_engine(SQLALCHEMY_DATABASE_URL)
    
    inspector = inspect(engine)
    
    print("=== DATABASE SCHEMA DEBUG ===")
    
    # Check actual database columns
    if inspector.has_table('users'):
        db_columns = [c['name'] for c in inspector.get_columns('users')]
        print(f"✅ Database 'users' table columns: {db_columns}")
    else:
        print("❌ 'users' table does not exist in database")
        return
    
    # Check model definition columns
    try:
        model_columns = [c.name for c in models.User.__table__.columns]
        print(f"✅ Model User.__table__ columns: {model_columns}")
    except Exception as e:
        print(f"❌ Error accessing User.__table__: {e}")
        return
    
    # Check Base metadata
    if 'users' in Base.metadata.tables:
        meta_columns = [c.name for c in Base.metadata.tables['users'].columns]
        print(f"✅ Base.metadata 'users' columns: {meta_columns}")
    else:
        print("❌ 'users' table not found in Base.metadata")
    
    # Compare and identify differences
    missing_in_db = set(model_columns) - set(db_columns)
    extra_in_db = set(db_columns) - set(model_columns)
    
    if missing_in_db:
        print(f"❌ CRITICAL: Columns in model but missing in DB: {missing_in_db}")
    if extra_in_db:
        print(f"⚠️  Columns in DB but not in model: {extra_in_db}")
    
    if not missing_in_db and not extra_in_db:
        print("✅ Schema appears to match - the issue may be elsewhere")
    
    # Test model instantiation with full_name
    try:
        test_user = models.User(
            email="test@test.com",
            username="testuser",
            hashed_password="hashedpw",
            full_name="Test User"
        )
        print("✅ Model can be instantiated with full_name")
    except Exception as e:
        print(f"❌ Model instantiation failed: {e}")

if __name__ == "__main__":
    debug_schema_mismatch()
