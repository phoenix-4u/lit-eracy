from app.database import get_db, engine
from app import models
from sqlalchemy import inspect, text
from sqlalchemy.exc import NoSuchTableError

def inspect_table_columns(table_name: str):
    """
    Inspects a table and prints its column details.
    """
    print(f"\n--- Inspecting columns for table: '{table_name}' ---")
    try:
        inspector = inspect(engine)
        columns = inspector.get_columns(table_name)
        
        # Print header
        print(f"{'Column Name':<25} {'Type':<25} {'Nullable'}")
        print("-" * 60)
        
        # Print each column's details
        for column in columns:
            col_name = column['name']
            col_type = str(column['type'])
            col_nullable = column['nullable']
            print(f"{col_name:<25} {col_type:<25} {col_nullable}")

    except NoSuchTableError:
        print(f"Error: Table '{table_name}' does not exist.")
    except Exception as e:
        print(f"An error occurred while inspecting table '{table_name}': {e}")


def run_sql_query(query: str):
    """
    Executes a raw SQL query and prints the results.
    """
    try:
        with engine.connect() as connection:
            result = connection.execute(text(query))
            print(f"\n--- Successfully executed query: '{query}' ---")
            
            if result.returns_rows:
                rows = result.fetchall()
                if rows:
                    # Print header
                    print(list(result.keys()))
                    # Print rows
                    for row in rows:
                        print(row)
                else:
                    print("Query executed, but returned no rows.")
            else:
                print("Query executed successfully (e.g., an INSERT, UPDATE, or DELETE statement).")

    except Exception as e:
        print(f"Failed to execute query: {e}")

def test_database():
    try:
        with engine.connect():
            print("Database connection successful!")
            inspector = inspect(engine)
            tables = inspector.get_table_names()
            print(f"Existing tables: {tables}")
            if not tables:
                print("No tables found!")
        return True
    except Exception as e:
        print(f"Database connection failed: {e}")
        return False

if __name__ == "__main__":
    if test_database():
        # 1. Inspect the columns of the 'users' table
        inspect_table_columns('contents')

        # 2. Run a query to see the actual data in the table
        run_sql_query("SELECT * FROM contents LIMIT 5")


# from app.database import get_db, engine
# from app import models
# from sqlalchemy import inspect

# def test_database():
#     try:
#         # Test basic connection
#         db = next(get_db())
        
#         # Check if connection works
#         connection = engine.connect()
#         print("Database connection successful!")
        
#         # Check if tables exist
#         inspector = inspect(engine)
#         tables = inspector.get_table_names()
#         print(f"Existing tables: {tables}")
        
#         if not tables:
#             print("No tables found - you need to create them!")
        
#         connection.close()
#         return True
#     except Exception as e:
#         print(f"Database connection failed: {e}")
#         return False

# if __name__ == "__main__":
#     test_database()
