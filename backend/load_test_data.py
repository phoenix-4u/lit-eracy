
import os
import sys
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from datetime import datetime, timezone, timedelta
import random

# Add project root to the Python path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '.')))

from app.models.user import User
from app.models.content import Content
from app.models.lesson import Lesson
from app.models.task import Task
from app.models.achievement import Achievement
from app.models.user_progress import UserProgress
from app.models.user_achievement import UserAchievement
from app.models.parent_child import ParentChild
from app.models.user_points import UserPoints
from app.utils.auth import get_password_hash
from app.database import sync_engine as engine

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def load_test_data():
    db = SessionLocal()
    try:
        print("Clearing existing data...")
        db.query(UserAchievement).delete()
        db.query(UserProgress).delete()
        db.query(ParentChild).delete()
        db.query(UserPoints).delete()
        db.query(Achievement).delete()
        db.query(Task).delete()
        db.query(Lesson).delete()
        db.query(Content).delete()
        db.query(User).delete()
        db.commit()
        print("Existing data cleared.")

        # --- User Generation ---
        print("Generating users...")
        users = []
        roles = ["student", "parent", "teacher"]
        for i in range(20):
            role = random.choice(roles)
            age = None
            grade = None
            if role == "student":
                grade = random.randint(1, 12)
                age = grade + 5
            elif role == "parent":
                age = random.randint(30, 50)
            elif role == "teacher":
                age = random.randint(25, 60)

            user = User(
                username=f"user{i}",
                email=f"user{i}@example.com",
                hashed_password=get_password_hash("password"),
                full_name=f"User {i}",
                age=age,
                grade=grade,
                role=role,
                is_active=True
            )
            users.append(user)
        db.add_all(users)
        db.commit()
        print(f"{len(users)} users generated.")

        # --- Parent-Child Relationships ---
        print("Generating parent-child relationships...")
        parents = [u for u in users if u.role == 'parent']
        students = [u for u in users if u.role == 'student']
        for student in students:
            if parents:
                parent = random.choice(parents)
                parent_child_link = ParentChild(parent_id=parent.id, child_id=student.id)
                db.add(parent_child_link)
        db.commit()
        print("Parent-child relationships generated.")

        # --- Content Generation ---
        print("Generating content...")
        content_items = []
        content_types = ["article", "video", "quiz"]
        for i in range(50):
            content = Content(
                title=f"Content Title {i}",
                description=f"This is the description for content {i}.",
                content_type=random.choice(content_types),
                difficulty_level=random.randint(1, 5),
                age_group=f"{random.randint(6, 10)}-{random.randint(11, 15)}"
            )
            content_items.append(content)
        db.add_all(content_items)
        db.commit()
        print(f"{len(content_items)} content items generated.")

        # --- Lesson and Task Generation ---
        print("Generating lessons and tasks...")
        lessons = []
        for i in range(10):
            lesson = Lesson(
                grade=random.randint(1, 12),
                title=f"Lesson {i}",
                content=f"This is the content for lesson {i}."
            )
            lessons.append(lesson)
        db.add_all(lessons)
        db.commit()

        for lesson in lessons:
            for j in range(random.randint(2, 5)):
                task = Task(
                    lesson_id=lesson.id,
                    title=f"Task {j} for Lesson {lesson.id}",
                    description=f"Description for task {j}."
                )
                db.add(task)
        db.commit()
        print(f"{len(lessons)} lessons and associated tasks generated.")

        # --- Achievement Generation ---
        print("Generating achievements...")
        achievements = []
        achievement_names = ["First Steps", "Bookworm", "Quiz Master", "Top of the Class", "Daily Learner"]
        for name in achievement_names:
            achievement = Achievement(name=name)
            achievements.append(achievement)
        db.add_all(achievements)
        db.commit()
        print(f"{len(achievements)} achievements generated.")

        # --- User Progress, Points, and Achievements ---
        print("Simulating user progress, points, and achievements...")
        for user in users:
            if user.role == 'student':
                # User Points
                user_points = UserPoints(
                    user_id=user.id,
                    knowledge_gems=random.randint(0, 100),
                    word_coins=random.randint(0, 100),
                    imagination_sparks=random.randint(0, 100),
                    total_points=random.randint(0, 300),
                    current_streak=random.randint(0, 10),
                    longest_streak=random.randint(10, 50),
                    last_activity_date=datetime.now(timezone.utc) - timedelta(days=random.randint(0, 5))
                )
                db.add(user_points)

                # User Progress
                for _ in range(random.randint(5, 20)):
                    content_item = random.choice(content_items)
                    progress = UserProgress(
                        user_id=user.id,
                        content_id=content_item.id,
                        is_completed=random.choice([True, False]),
                        score=random.randint(50, 100),
                        time_spent=random.randint(300, 3600),
                        completed_at=datetime.now(timezone.utc) if random.choice([True, False]) else None
                    )
                    db.add(progress)

                # User Achievements
                for _ in range(random.randint(0, len(achievements))):
                    achievement = random.choice(achievements)
                    user_achievement = UserAchievement(
                        user_id=user.id,
                        achievement_id=achievement.id,
                        earned_at=datetime.now(timezone.utc)
                    )
                    db.add(user_achievement)
        db.commit()
        print("User progress, points, and achievements simulated.")

        print("Database loaded with test data successfully.")
    finally:
        db.close()

if __name__ == "__main__":
    load_test_data()
