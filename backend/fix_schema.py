from sqlalchemy import inspect
from app.database import engine, Base
from app import models  # This imports all your models

def fix_database_schema():
    print("Current database schema:")
    inspector = inspect(engine)
    
    # Show current users table columns
    if inspector.has_table('users'):
        columns = inspector.get_columns('users')
        print("Current 'users' table columns:")
        for column in columns:
            print(f"  - {column['name']}: {column['type']}")
    
    print("\nDropping all tables...")
    Base.metadata.drop_all(bind=engine)
    
    print("Creating all tables with current model definitions...")
    Base.metadata.create_all(bind=engine)
    
    print("✅ Database schema updated successfully!")
    
    # Verify the new schema
    print("\nNew 'users' table columns:")
    columns = inspector.get_columns('users')
    for column in columns:
        print(f"  ✅ {column['name']}: {column['type']}")

if __name__ == "__main__":
    fix_database_schema()
