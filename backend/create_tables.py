from app.database import engine, Base
import app.models  # ensures all models are imported

if __name__ == "__main__":
    Base.metadata.create_all(bind=engine)
    print("Database tables created.")
