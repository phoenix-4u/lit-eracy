# File: backend/app/services/voice_qna_service.py

import asyncio
import json
import logging
import base64
from io import BytesIO
from typing import Dict, Any, Optional

import aiohttp
from pydub import AudioSegment
import speech_recognition as sr
from gtts import gTTS

logger = logging.getLogger(__name__)

class VoiceQnAService:
    def __init__(
        self,
        ollama_url: str = "http://localhost:11434",
        model: str = "gemma3:2b"
    ):
        self.ollama_base_url = ollama_url
        self.model_name = model
        self.recognizer = sr.Recognizer()

    async def process_voice_question(
        self,
        audio_data: bytes,
        lesson_context: str = "",
        grade_level: int = None
    ) -> Dict[str, Any]:
        """Process a voice question and return both text and audio answer."""
        try:
            # Convert speech to text
            question_text = await self._speech_to_text(audio_data)
            if not question_text:
                return {
                    "success": False,
                    "error": "Could not understand the audio. Please try again."
                }

            logger.info(f"Voice question recognized: {question_text}")

            # Generate AI answer
            answer_text = await self._generate_answer(
                question_text, lesson_context, grade_level
            )
            if not answer_text:
                return {
                    "success": False,
                    "error": "Could not generate an AI answer. Please try again."
                }

            # Convert text answer to speech
            audio_response = await self._text_to_speech(answer_text)

            return {
                "success": True,
                "question": question_text,
                "answer": answer_text,
                "audio_response": audio_response
            }

        except Exception as e:
            logger.error(f"Error in process_voice_question: {e}")
            return {
                "success": False,
                "error": "Internal server error during voice processing."
            }

    async def _speech_to_text(self, audio_data: bytes) -> Optional[str]:
        """Convert raw audio bytes into text using Google's STT."""
        try:
            # Load audio bytes into pydub AudioSegment
            buffer = BytesIO(audio_data)
            audio = AudioSegment.from_file(buffer)
            # Resample and convert to mono WAV format
            audio = audio.set_frame_rate(16000).set_channels(1)

            # Export processed audio to an in-memory WAV buffer
            wav_buffer = BytesIO()
            audio.export(wav_buffer, format="wav")
            wav_buffer.seek(0)

            # Recognize speech from the in-memory WAV
            with sr.AudioFile(wav_buffer) as source:
                recorded = self.recognizer.record(source)
                text = self.recognizer.recognize_google(recorded)
                return text

        except sr.UnknownValueError:
            logger.warning("SpeechRecognition could not understand audio")
            return None
        except sr.RequestError as e:
            logger.error(f"SpeechRecognition request error: {e}")
            return None
        except Exception as e:
            logger.error(f"Error in _speech_to_text: {e}")
            return None

    async def _generate_answer(
        self,
        question: str,
        lesson_context: str = "",
        grade_level: int = None
    ) -> Optional[str]:
        """Generate an AI answer via Ollama."""
        try:
            system_prompt = self._get_system_prompt(grade_level)
            prompt = f"""
{system_prompt}

Lesson Context:
{lesson_context}

Student Question:
{question}

Provide a friendly, concise answer appropriate for Grade {grade_level or 'elementary'} students.
Answer:
"""

            payload = {
                "model": self.model_name,
                "prompt": prompt,
                "stream": False,
                "options": {
                    "temperature": 0.7,
                    "top_p": 0.9,
                    "max_tokens": 150
                }
            }

            async with aiohttp.ClientSession(
                timeout=aiohttp.ClientTimeout(total=60)
            ) as session:
                async with session.post(
                    f"{self.ollama_base_url}/api/generate",
                    json=payload,
                    headers={"Content-Type": "application/json"}
                ) as response:
                    if response.status == 200:
                        result = await response.json()
                        answer = result.get("response", "").strip()
                        return self._clean_for_tts(answer)
                    else:
                        logger.error(f"Ollama returned status {response.status}")
                        return None

        except Exception as e:
            logger.error(f"Error in _generate_answer: {e}")
            return None

    def _get_system_prompt(self, grade_level: int = None) -> str:
        """Return an age-appropriate system prompt."""
        if grade_level and grade_level <= 2:
            return (
                "You are a friendly teacher for very young students (ages 5–7). "
                "Use simple words, gentle tone, and clear explanations."
            )
        elif grade_level and grade_level <= 5:
            return (
                "You are an elementary school teacher (ages 8–11). "
                "Be encouraging and explain step-by-step in simple language."
            )
        elif grade_level and grade_level <= 8:
            return (
                "You are a middle school teacher (ages 12–14). "
                "Be clear and supportive with examples."
            )
        else:
            return (
                "You are an AI teaching assistant. Provide clear, concise, and "
                "helpful explanations."
            )

    def _clean_for_tts(self, text: str) -> str:
        """Clean markdown and excessive punctuation before TTS."""
        # Remove markdown syntax
        clean = text.replace("**", "").replace("*", "")
        # Normalize ellipses
        clean = clean.replace("...", ".").replace("..", ".")
        # Ensure proper sentence ending
        if not clean.endswith((".", "?", "!")):
            clean += "."
        return clean

    async def _text_to_speech(self, text: str) -> str:
        """Convert text to speech and return base64-encoded MP3."""
        try:
            tts = gTTS(text=text, lang="en", slow=False)
            mp3_buffer = BytesIO()
            tts.write_to_fp(mp3_buffer)
            mp3_buffer.seek(0)
            audio_bytes = mp3_buffer.read()
            return base64.b64encode(audio_bytes).decode("utf-8")
        except Exception as e:
            logger.error(f"Error in _text_to_speech: {e}")
            return ""
