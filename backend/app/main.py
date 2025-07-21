from fastapi import FastAPI
from .routes import auth, users, content, achievements

app = FastAPI(title="AI Literacy API", version="1.0.0")

app.include_router(auth.router)
app.include_router(users.router)
app.include_router(content.router, prefix="/content")
app.include_router(achievements.router, prefix="/achievements")
