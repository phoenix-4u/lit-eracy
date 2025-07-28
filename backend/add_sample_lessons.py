from app.database import SessionLocal, engine, Base
from app.models import Content
from app import models

def add_sample_lessons():
    ensure_tables_exist()
    db = SessionLocal()
    
    try:
        print("=== Cleaning Previous Data ===")
        
        # ✅ Delete existing lessons with invalid data
        existing_lessons = db.query(Content).filter(
            Content.content_type == "lesson",
            Content.difficulty_level == 1
        ).all()
        
        if existing_lessons:
            print(f"Found {len(existing_lessons)} existing lessons to delete:")
            for lesson in existing_lessons:
                print(f"  - {lesson.title} (age_group: '{lesson.age_group}')")
            
            # Delete all existing grade 1 lessons
            db.query(Content).filter(
                Content.content_type == "lesson",
                Content.difficulty_level == 1
            ).delete()
            db.commit()
            print("✅ Previous lessons deleted")
        else:
            print("No existing lessons found")
        
        print("\n=== Adding New Valid Data ===")
        
        # Add corrected sample lessons with valid age groups
        sample_lessons = [
            Content(
                title="Introduction to AI - Grade 1",
                description="Basic AI concepts for young learners",
                content_type="lesson",
                difficulty_level=1,
                age_group="7-10",  # ✅ Valid enum value
                content_data='{"lesson": "What is AI?", "duration": "10 minutes"}',
                is_active=True
            ),
            Content(
                title="AI in Everyday Life - Grade 1",
                description="How AI helps us daily",
                content_type="lesson", 
                difficulty_level=1,
                age_group="7-10",  # ✅ Valid enum value
                content_data='{"lesson": "AI around us", "duration": "8 minutes"}',
                is_active=True
            )
        ]
        
        for lesson in sample_lessons:
            db.add(lesson)
        
        db.commit()
        print(f"✅ Added {len(sample_lessons)} new lessons with valid data")
        
        # Verify the fix
        all_lessons = db.query(Content).filter(
            Content.content_type == "lesson",
            Content.difficulty_level == 1,
            Content.is_active == True
        ).all()
        
        print(f"\nFinal verification - Total grade 1 lessons: {len(all_lessons)}")
        for lesson in all_lessons:
            print(f"  ✅ {lesson.title}")
            print(f"     Age Group: '{lesson.age_group}' (valid: {'7-10' in ['3-6', '7-10', '11-14']})")
            
    except Exception as e:
        print(f"❌ Error: {e}")
        db.rollback()
    finally:
        db.close()

def ensure_tables_exist():
    print("Ensuring database tables exist...")
    Base.metadata.create_all(bind=engine)
    print("✅ Database tables ready")

if __name__ == "__main__":
    add_sample_lessons()
