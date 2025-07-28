import os
import sys
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from datetime import datetime, timezone

# Import password hashing utility
from app.utils.auth import get_password_hash

# Add project root to the Python path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '.')))

from app.models.user import User
from app.models.content import Content
from app.models.lesson import Lesson
from app.models.achievement import Achievement
from app.models.user_progress import UserProgress
from app.models.user_achievement import UserAchievement
from app.database import engine

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def populate_db():
    db = SessionLocal()
    try:
        # Clear existing data
        db.query(UserAchievement).delete()
        db.query(UserProgress).delete()
        db.query(Achievement).delete()
        db.query(Lesson).delete()
        db.query(Content).delete()
        db.query(User).delete()
        db.commit()
        # Create Users
        user1 = User(
            username="testuser1",
            email="testuser1@example.com",
            hashed_password=get_password_hash("password1"),
            full_name="Test User 1"
        )
        user2 = User(
            username="testuser2",
            email="testuser2@example.com",
            hashed_password=get_password_hash("password2"),
            full_name="Test User 2"
        )
        db.add_all([user1, user2])
        db.commit()

        # Create Content
        content1 = Content(title="Introduction to AI", description="A beginner's guide to AI.", content_type="article", age_group="10-12")
        content2 = Content(title="Advanced Python", description="Deep dive into Python.", content_type="video", age_group="15-18")
        db.add_all([content1, content2])
        db.commit()

        # Create Lessons
        lesson1 = Lesson(grade=5, title="What is AI?", content="This is a lesson about AI.")
        lesson2 = Lesson(grade=10, title="Python Basics", content="This is a lesson about Python.")
        db.add_all([lesson1, lesson2])
        db.commit()

        # Create Tasks for Lessons
        from app.models.task import Task
        task1 = Task(lesson_id=lesson1.id, title="Define AI", description="Write a short definition of Artificial Intelligence.")
        task2 = Task(lesson_id=lesson1.id, title="List AI examples", description="List 3 examples of AI in daily life.")
        task3 = Task(lesson_id=lesson2.id, title="Print Hello World", description="Write a Python program to print 'Hello World'.")
        db.add_all([task1, task2, task3])
        db.commit()

        # Create Achievements
        achievement1 = Achievement(name="First Lesson Completed")
        achievement2 = Achievement(name="Python Master")
        db.add_all([achievement1, achievement2])
        db.commit()

        # Create User Progress
        progress1 = UserProgress(user_id=user1.id, content_id=content1.id, is_completed=True, completed_at=datetime.now(timezone.utc))
        db.add(progress1)
        db.commit()

        # Create User Achievements
        user_achievement1 = UserAchievement(user_id=user1.id, achievement_id=achievement1.id, earned_at=datetime.now(timezone.utc))
        db.add(user_achievement1)
        db.commit()

        print("Database populated with dummy data.")
    finally:
        db.close()

if __name__ == "__main__":
    populate_db()
