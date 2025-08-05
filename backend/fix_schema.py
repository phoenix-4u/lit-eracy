# File: create_tasks_with_samples.py
"""
Creates the 'tasks' table (if missing) and inserts sample tasks.
Run once from your backend virtual-env:  python create_tasks_with_samples.py
"""

import os
import sqlite3
import datetime

DB_PATH = "app.db"        # adjust if your database file has a different name

CREATE_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS tasks (
    id           INTEGER  PRIMARY KEY AUTOINCREMENT,
    title        VARCHAR(255) NOT NULL,
    description  TEXT,
    lesson_id    INTEGER NOT NULL,
    is_completed INTEGER DEFAULT 0,
    created_at   TEXT    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lesson_id) REFERENCES lessons (id)
);
"""

SAMPLE_TASKS = [
    ("Count from 1 to 10",      "Practice counting objects from 1 to 10."),
    ("Number Recognition",      "Match numerals with correct quantities."),
    ("Basic Addition Drill",    "Add two single-digit numbers together."),
]

def main() -> None:
    if not os.path.exists(DB_PATH):
        raise FileNotFoundError(f"Database file '{DB_PATH}' not found")

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # 1️⃣  Create tasks table if it doesn’t exist
    cursor.execute(CREATE_TABLE_SQL)
    conn.commit()

    # 2️⃣  Get first lesson id (needed for FK)
    cursor.execute("SELECT id FROM lessons ORDER BY id LIMIT 1;")
    row = cursor.fetchone()
    if row is None:
        raise RuntimeError("No lessons found. Please add at least one lesson first.")
    lesson_id = row[0]

    # 3️⃣  Insert sample tasks (skip if a task with same title already exists)
    for title, desc in SAMPLE_TASKS:
        cursor.execute(
            "SELECT 1 FROM tasks WHERE title = ? AND lesson_id = ?;",
            (title, lesson_id),
        )
        if cursor.fetchone():
            print(f"🛈  Task '{title}' already exists – skipping.")
            continue
        cursor.execute(
            """
            INSERT INTO tasks (title, description, lesson_id, is_completed, created_at)
            VALUES (?, ?, ?, 0, ?);
            """,
            (title, desc, lesson_id, datetime.datetime.utcnow().isoformat()),
        )
        print(f"✅  Inserted task: {title}")

    conn.commit()
    conn.close()
    print("🎉  Tasks table ready with sample data!")

if __name__ == "__main__":
    main()
