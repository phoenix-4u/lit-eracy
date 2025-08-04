# File: backend/create_tables.py

import os
import sys

# Make sure your project root is on PYTHONPATH
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.database import sync_engine  # the Engine bound to DATABASE_URL
from app.base import Base             # your single shared Base
import app.models                      # ensures all model classes are imported and registered

def main():
    """
    Create all database tables defined on Base.
    """
    print(f"Creating database tables on {sync_engine.url}...")
    Base.metadata.create_all(bind=sync_engine)
    print("✅ Tables created successfully.")

if __name__ == "__main__":
    main()
