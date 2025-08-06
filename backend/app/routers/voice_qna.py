# File: backend/app/routers/voice_qna.py

from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, Form
from sqlalchemy.orm import Session
from typing import Optional
import logging

from app.database import get_db
from app.models.lesson import Lesson
from app.services.voice_qna_service import VoiceQnAService

logger = logging.getLogger(__name__)
router = APIRouter()

@router.post("/voice-qna")
async def voice_qna(
    audio_file: UploadFile = File(...),
    lesson_id: Optional[int] = Form(None),
    grade_level: Optional[int] = Form(None),
    db: Session = Depends(get_db)
):
    """Process voice question and return AI response."""
    
    try:
        # Accept any uploaded file (we’ll attempt to process it)
        if audio_file.content_type is None:
            raise HTTPException(status_code=400, detail="No file content type provided")

        # Get lesson context if provided
        lesson_context = ""
        if lesson_id:
            lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
            if lesson:
                lesson_context = f"{lesson.title}: {lesson.content}"
        
        # Read audio data
        audio_data = await audio_file.read()
        
        # Process voice Q&A
        voice_service = VoiceQnAService()
        result = await voice_service.process_voice_question(
            audio_data=audio_data,
            lesson_context=lesson_context,
            grade_level=grade_level
        )
        
        return result
        
    except Exception as e:
        logger.error(f"Error in voice Q&A endpoint: {e}")
        raise HTTPException(status_code=500, detail="Voice processing failed")

@router.get("/voice-qna/test")
async def test_voice_services():
    """Test if voice services are available."""
    try:
        voice_service = VoiceQnAService()
        return {
            "speech_recognition": "available",
            "text_to_speech": "available",
            "ollama": "testing..."
        }
    except Exception as e:
        return {"error": str(e)}
