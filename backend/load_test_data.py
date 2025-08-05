# File: backend/load_test_data.py

"""
Clear all existing data then insert comprehensive test data.
Adjusts to actual model fields (Achievement only has 'name').
Run once: python load_test_data.py
"""

import os
import sys
import random
from datetime import datetime, timezone, timedelta
from pathlib import Path
from sqlalchemy.orm import sessionmaker

# Add project root to path
sys.path.append(str(Path(__file__).parent))

from app.database import sync_engine as engine
from app.utils.auth import get_password_hash

from app.models.user import User
from app.models.parent_child import ParentChild
from app.models.content import Content
from app.models.lesson import Lesson
from app.models.task import Task
from app.models.achievement import Achievement
from app.models.user_points import UserPoints
from app.models.user_progress import UserProgress
from app.models.user_achievement import UserAchievement
from app.models.notification import Notification
from app.models.chat_message import ChatMessage

SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)

# Config
NUM_USERS          = 30
NUM_CONTENT        = 60
NUM_LESSONS        = 15
TASKS_PER_LESSON   = (2, 5)
ACHIEVEMENT_NAMES  = [
    "First Steps", "Bookworm", "Quiz Master", "Top of the Class",
    "Daily Learner", "Math Wizard", "Science Explorer", "History Buff",
    "Creative Artist", "Reading Champion"
]
NOTIFICATION_COUNT = 3
CHAT_MESSAGES      = 40

rng = random.Random(42)

def utc_now():
    return datetime.now(timezone.utc)

def load_test_data():
    db = SessionLocal()
    try:
        print("🔄 Clearing existing data…")
        for model in (
            ChatMessage, Notification, UserAchievement, UserProgress,
            UserPoints, ParentChild, Task, Lesson, Achievement,
            Content, User
        ):
            db.query(model).delete()
        db.commit()
        print("✅ Data cleared.\n")

        # Users
        print("👥 Creating users…")
        roles=["student","parent","teacher"]
        users=[]
        for i in range(NUM_USERS):
            role=rng.choice(roles)
            grade= rng.randint(1,12) if role=="student" else None
            age= grade+5 if role=="student" else rng.randint(25,60)
            users.append(User(
                username=f"user{i}",
                email=f"user{i}@example.com",
                hashed_password=get_password_hash("password"),
                full_name=f"User {i}",
                role=role,
                grade=grade,
                age=age,
                is_active=True
            ))
        db.add_all(users); db.commit()
        print(f"   → {len(users)} users\n")

        # Parent-Child
        parents=[u for u in users if u.role=="parent"]
        students=[u for u in users if u.role=="student"]
        print("👨‍👩‍👧 Creating parent-child links…")
        for stu in students:
            if parents:
                pr=rng.choice(parents)
                db.add(ParentChild(parent_id=pr.id, child_id=stu.id))
        db.commit(); print(f"   → {len(students)} links\n")

        # Content
        print("📚 Creating content…")
        c_types=["article","video","quiz"]
        contents=[]
        for i in range(NUM_CONTENT):
            contents.append(Content(
                title=f"Content {i}",
                description=f"This is the description for content {i}.",
                content_type=rng.choice(c_types),
                difficulty_level=rng.randint(1,5),
                age_group=f"{rng.randint(6,10)}-{rng.randint(11,15)}"
            ))
        db.add_all(contents); db.commit()
        print(f"   → {len(contents)} content\n")

        # Lessons & Tasks
        print("📖 Creating lessons & tasks…")
        subjects=["Math","English","Science","History","Art"]
        lessons=[]
        for i in range(NUM_LESSONS):
            subj=rng.choice(subjects)
            lessons.append(Lesson(
                grade=rng.randint(1,12),
                title=f"{subj} Lesson {i+1}",
                content=f"Detailed content for {subj} lesson {i+1}."
            ))
        db.add_all(lessons); db.commit()
        task_count=0
        for les in lessons:
            for j in range(rng.randint(*TASKS_PER_LESSON)):
                db.add(Task(
                    lesson_id=les.id,
                    title=f"Task {j+1} for {les.title}",
                    description=f"Complete activities for {les.title}.",
                    is_completed=rng.choice([0,1])
                ))
                task_count+=1
        db.commit()
        print(f"   → {len(lessons)} lessons, {task_count} tasks\n")

        # Achievements
        print("🏆 Creating achievements…")
        achs=[Achievement(name=n) for n in ACHIEVEMENT_NAMES]
        db.add_all(achs); db.commit()
        print(f"   → {len(achs)} achievements\n")

        # Points/Progress/Achievements
        print("📈 Simulating student data…")
        for stu in students:
            db.add(UserPoints(
                user_id=stu.id,
                knowledge_gems=rng.randint(0,100),
                word_coins=rng.randint(0,100),
                imagination_sparks=rng.randint(0,100),
                total_points=rng.randint(0,300),
                current_streak=rng.randint(0,10),
                longest_streak=rng.randint(10,50),
                last_activity_date=utc_now()-timedelta(days=rng.randint(0,5))
            ))
            for _ in range(rng.randint(5,15)):
                c=rng.choice(contents)
                db.add(UserProgress(
                    user_id=stu.id,
                    content_id=c.id,
                    is_completed=rng.choice([True,False]),
                    score=rng.randint(50,100),
                    time_spent=rng.randint(60,1800),
                    completed_at=utc_now() if rng.choice([True,False]) else None
                ))
            earned=rng.sample(achs,k=rng.randint(0,len(achs)))
            for a in earned:
                db.add(UserAchievement(
                    user_id=stu.id,
                    achievement_id=a.id,
                    earned_at=utc_now()-timedelta(days=rng.randint(0,30))
                ))
        db.commit()
        print("   → Points/progress/achievements done\n")

        # Notifications
        print("🔔 Creating notifications…")
        for u in users:
            for _ in range(rng.randint(0,NOTIFICATION_COUNT)):
                db.add(Notification(
                    user_id=u.id,
                    title="Reminder",
                    message="Don't forget your tasks!",
                    sent_at=utc_now()
                ))
        db.commit(); print("   → Notifications done\n")

        # Chat Messages
        print("💬 Creating chat messages…")
        if len(students)>1:
            for _ in range(CHAT_MESSAGES):
                s,r=rng.sample(students,2)
                db.add(ChatMessage(
                    sender_id=s.id,
                    receiver_id=r.id,
                    message="Let's study together!",
                    sent_at=utc_now()
                ))
            db.commit(); print(f"   → {CHAT_MESSAGES} messages\n")
        else:
            print("   → Skipped chat (not enough students)\n")

        print("🎉 LOAD COMPLETE!")
    except Exception as e:
        print(f"❌ {e}")
        db.rollback()
        raise
    finally:
        db.close()

if __name__=="__main__":
    load_test_data()
