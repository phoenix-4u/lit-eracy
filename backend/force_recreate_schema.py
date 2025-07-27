import sys
import importlib

# Force reload of all modules
modules_to_reload = [
    'app.models',
    'app.database',
    'app'
]

for module_name in modules_to_reload:
    if module_name in sys.modules:
        print(f"Reloading module: {module_name}")
        importlib.reload(sys.modules[module_name])

# Now import fresh versions
from app.database import engine, Base
from app import models  # Fresh import
from sqlalchemy import inspect

def force_recreate_tables():
    print("=== Force Recreating Database Schema ===")
    
    # Verify models are properly loaded
    print(f"Models in Base.registry: {len(Base.registry.mappers)}")
    for mapper in Base.registry.mappers:
        print(f"  - {mapper.class_.__name__}")
    
    print("\nDropping all tables...")
    Base.metadata.drop_all(bind=engine)
    
    print("Creating all tables with fresh model definitions...")
    Base.metadata.create_all(bind=engine)
    
    print("✅ Schema recreation complete!")
    
    # Verify the new schema
    inspector = inspect(engine)
    if inspector.has_table('users'):
        columns = inspector.get_columns('users')
        print(f"\nNew 'users' table columns ({len(columns)} total):")
        for column in columns:
            print(f"  ✅ {column['name']}: {column['type']}")
    else:
        print("❌ Users table was not created!")

if __name__ == "__main__":
    force_recreate_tables()
