from app.database import get_db, engine
from app import models
from sqlalchemy import inspect

def test_database():
    try:
        # Test basic connection
        db = next(get_db())
        
        # Check if connection works
        connection = engine.connect()
        print("Database connection successful!")
        
        # Check if tables exist
        inspector = inspect(engine)
        tables = inspector.get_table_names()
        print(f"Existing tables: {tables}")
        
        if not tables:
            print("No tables found - you need to create them!")
        
        connection.close()
        return True
    except Exception as e:
        print(f"Database connection failed: {e}")
        return False

if __name__ == "__main__":
    test_database()
