# File: backend/create_user.py

import os
import sys

# Make sure your project root is on PYTHONPATH
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.database import SessionLocal
from app.models.user import User
from app.models.user_points import UserPoints
from app.core.security import get_password_hash

from app.models.parent_child import ParentChild

def create_parent_child():
    db = SessionLocal()
    parent = db.query(User).filter(User.role=="parent").first()
    child = db.query(User).filter(User.role=="student").first()
    if parent and child:
        db.add(ParentChild(parent_id=parent.id, child_id=child.id))
        db.commit()
    db.close()

def create_users_by_role():
    """Create test users for all three roles: student, teacher, parent"""
    
    users_data = [
        # STUDENT USER
        {
            "username": "student_test",
            "email": "student@example.com",
            "full_name": "Emma Johnson",
            "age": 10,
            "grade": 5,
            "role": "student",
            "parent_email": "parent@example.com",
            "password": "student123"
        },
        
        # TEACHER USER  
        {
            "username": "teacher_test",
            "email": "teacher@example.com",
            "full_name": "Ms. Sarah Wilson",
            "age": 32,
            "grade": None,  # Teachers don't have a grade
            "role": "teacher", 
            "parent_email": None,  # Teachers don't have parent emails
            "password": "teacher123"
        },
        
        # PARENT USER
        {
            "username": "parent_test",
            "email": "parent@example.com", 
            "full_name": "David Johnson",
            "age": 42,
            "grade": None,  # Parents don't have a grade
            "role": "parent",
            "parent_email": None,  # Parents don't have parent emails
            "password": "parent123"
        }
    ]
    
    db = SessionLocal()
    
    try:
        for user_data in users_data:
            # Check if user already exists
            existing_user = db.query(User).filter(
                (User.email == user_data["email"]) | (User.username == user_data["username"])
            ).first()
            
            if existing_user:
                print(f"🔄 User {user_data['username']} ({user_data['role']}) already exists, skipping...")
                continue
            
            # Create user
            db_user = User(
                username=user_data["username"],
                email=user_data["email"],
                hashed_password=get_password_hash(user_data["password"]),
                full_name=user_data["full_name"],
                age=user_data["age"],
                grade=user_data["grade"],
                role=user_data["role"],
                parent_email=user_data["parent_email"],
                is_active=True,
                avatar_url=None
            )
            
            db.add(db_user)
            db.commit()
            db.refresh(db_user)
            
            # Create UserPoints ONLY for students
            # Teachers and parents don't need points in the current system
            if db_user.role == "student":
                user_points = UserPoints(
                    user_id=db_user.id,
                    knowledge_gems=0,
                    word_coins=0,
                    imagination_sparks=0,
                    total_points=0,
                    current_streak=0,
                    longest_streak=0
                )
                db.add(user_points)
                db.commit()
                print(f"✅ Created STUDENT: {db_user.username} with UserPoints")
            
            elif db_user.role == "teacher":
                print(f"✅ Created TEACHER: {db_user.username}")
                
            elif db_user.role == "parent":  
                print(f"✅ Created PARENT: {db_user.username}")
            
            print(f"   📧 Email: {db_user.email}")
            print(f"   🔑 Password: {user_data['password']}")
            print(f"   👤 Full Name: {db_user.full_name}")
            print(f"   🆔 User ID: {db_user.id}")
            print("-" * 50)
            
    except Exception as e:
        print(f"❌ Error creating users: {e}")
        db.rollback()
    finally:
        db.close()

def create_additional_students():
    """Create additional student users for testing"""
    students_data = [
        {
            "username": "alice_student",
            "email": "alice@example.com", 
            "full_name": "Alice Smith",
            "age": 8,
            "grade": 3,
            "parent_email": "parent@example.com"
        },
        {
            "username": "bob_student",
            "email": "bob@example.com",
            "full_name": "Bob Wilson", 
            "age": 12,
            "grade": 7,
            "parent_email": "parent@example.com"
        }
    ]
    
    db = SessionLocal()
    
    try:
        for student_data in students_data:
            existing_user = db.query(User).filter(
                (User.email == student_data["email"]) | (User.username == student_data["username"])
            ).first()
            
            if existing_user:
                print(f"🔄 Student {student_data['username']} already exists, skipping...")
                continue
                
            db_user = User(
                username=student_data["username"],
                email=student_data["email"],
                hashed_password=get_password_hash("password123"),
                full_name=student_data["full_name"],
                age=student_data["age"],
                grade=student_data["grade"],
                role="student",
                parent_email=student_data["parent_email"],
                is_active=True
            )
            
            db.add(db_user)
            db.commit() 
            db.refresh(db_user)
            
            # Create points for student
            user_points = UserPoints(
                user_id=db_user.id,
                knowledge_gems=0,
                word_coins=0,
                imagination_sparks=0,
                total_points=0,
                current_streak=0,
                longest_streak=0
            )
            db.add(user_points)
            db.commit()
            
            print(f"✅ Created additional student: {db_user.username}")

            
            
    except Exception as e:
        print(f"❌ Error creating additional students: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    print("🚀 Creating test users for all roles...")
    print("=" * 60)
    
    create_users_by_role()
    create_parent_child()
    
    print("\n🎓 Creating additional students...")
    create_additional_students()
    
    print("\n✨ All users created! You can now test login with:")
    print("📚 Student: student@example.com / student123")
    print("👨‍🏫 Teacher: teacher@example.com / teacher123") 
    print("👨‍👩‍👧‍👦 Parent: parent@example.com / parent123")
    print("Done!")
