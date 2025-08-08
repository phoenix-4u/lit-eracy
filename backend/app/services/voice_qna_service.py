# File: backend/app/services/voice_qna_service.py

import asyncio
import json
import logging
import base64
import wave
import struct
import tempfile
import os
from io import BytesIO
from typing import Dict, Any, Optional

import aiohttp
import speech_recognition as sr
from gtts import gTTS
import av

try:
    import librosa
    import soundfile as sf
    LIBROSA_AVAILABLE = True
except ImportError:
    LIBROSA_AVAILABLE = False
    logging.warning("librosa not available - limited audio format support")

logger = logging.getLogger(__name__)

class VoiceQnAService:
    def __init__(
        self,
        ollama_url: str = "http://localhost:11434",
        model: str = "gemma3n:e2b"
    ):
        self.ollama_base_url = ollama_url
        self.model_name = model
        self.recognizer = sr.Recognizer()
        # Improve recognition settings
        self.recognizer.energy_threshold = 300
        self.recognizer.dynamic_energy_threshold = True

    async def process_voice_question(
        self,
        audio_data: bytes,
        lesson_context: str = "",
        grade_level: int = None
    ) -> Dict[str, Any]:
        """Process voice question and return text answer with audio response."""
        try:
            # Step 1: Convert audio to text
            question_text = await self._speech_to_text(audio_data)
            if not question_text:
                return {
                    "success": False,
                    "error": "Could not understand the audio. Please speak clearly and try again."
                }

            logger.info(f"Voice question: {question_text}")

            # Step 2: Generate AI response
            answer_text = await self._generate_answer(question_text, lesson_context, grade_level)
            if not answer_text:
                return {
                    "success": False,
                    "error": "Could not generate an answer. Please try again."
                }

            # Step 3: Convert answer to speech
            audio_response = await self._text_to_speech(answer_text)

            return {
                "success": True,
                "question": question_text,
                "answer": answer_text,
                "audio_response": audio_response
            }

        except Exception as e:
            logger.error(f"Error in voice Q&A: {e}")
            return {
                "success": False,
                "error": "Something went wrong. Please try again."
            }

    async def _debug_audio_data(self, audio_data: bytes) -> None:
        """Debug audio data to understand what we're receiving."""
        logger.info(f"Received audio data: {len(audio_data)} bytes")
        logger.info(f"First 20 bytes: {audio_data[:20]}")
        
        # Check for common audio file signatures
        if audio_data.startswith(b'RIFF'):
            logger.info("Audio format: WAV")
        elif audio_data.startswith(b'\x1a\x45\xdf\xa3'):
            logger.info("Audio format: WebM")
        elif audio_data.startswith(b'ftyp'):
            logger.info("Audio format: MP4/M4A")
        elif audio_data.startswith(b'\xff\xf1') or audio_data.startswith(b'\xff\xf9'):
            logger.info("Audio format: AAC")
        elif audio_data[:4] == b'OggS':
            logger.info("Audio format: OGG")
        else:
            logger.info("Audio format: Unknown/Raw")

    async def _speech_to_text(self, audio_data: bytes) -> Optional[str]:
        """Convert speech audio to text using multiple fallback methods."""
        await self._debug_audio_data(audio_data)
        
        try:
            # Prioritize AAC conversion if data looks like AAC
            if audio_data.startswith(b'\xff\xf1') or audio_data.startswith(b'\xff\xf9'):
                wav_data = await self._convert_aac_to_wav_with_av(audio_data)
                if wav_data:
                    return await self._recognize_from_wav(wav_data)
            
            # Fallback to other methods if not AAC or if conversion fails
            if LIBROSA_AVAILABLE:
                wav_data = await self._convert_with_librosa(audio_data)
                if wav_data:
                    return await self._recognize_from_wav(wav_data)
            
            elif audio_data.startswith(b'RIFF'):
                return await self._recognize_from_wav(audio_data)
            
            return await self._process_raw_pcm(audio_data)

        except sr.UnknownValueError:
            logger.warning("Could not understand audio")
            return None
        except sr.RequestError as e:
            logger.error(f"Speech recognition error: {e}")
            return None
        except Exception as e:
            logger.error(f"Error in speech to text: {e}")
            return None

    async def _convert_aac_to_wav_with_av(self, aac_data: bytes) -> Optional[bytes]:
        """Convert AAC to WAV in memory using PyAV."""
        try:
            input_buffer = BytesIO(aac_data)
            output_buffer = BytesIO()

            with av.open(input_buffer, mode='r') as input_container:
                input_stream = input_container.streams.audio[0]
                
                output_container = av.open(output_buffer, mode='w', format='wav')
                output_stream = output_container.add_stream('pcm_s16le', rate=16000, layout='mono')

                for frame in input_container.decode(input_stream):
                    for packet in output_stream.encode(frame):
                        output_container.mux(packet)

                # Flush any remaining packets
                for packet in output_stream.encode(None):
                    output_container.mux(packet)

                output_container.close()

            output_buffer.seek(0)
            return output_buffer.read()

        except Exception as e:
            logger.error(f"Error converting AAC with PyAV: {e}")
            return None

    async def _convert_aac_to_wav_fallback(self, aac_data: bytes) -> Optional[bytes]:
        """Fallback AAC to WAV conversion without librosa."""
        try:
            # AAC ADTS parsing - extract raw audio frames
            frames = []
            pos = 0
            
            while pos < len(aac_data) - 7:
                # Look for ADTS sync word (0xFFF)
                if aac_data[pos] == 0xFF and (aac_data[pos + 1] & 0xF0) == 0xF0:
                    # Calculate frame length from ADTS header
                    frame_length = ((aac_data[pos + 3] & 0x03) << 11) | \
                                 (aac_data[pos + 4] << 3) | \
                                 ((aac_data[pos + 5] & 0xE0) >> 5)
                    
                    if frame_length > 7 and pos + frame_length <= len(aac_data):
                        # Extract raw AAC frame data (skip 7-byte ADTS header)
                        frame_data = aac_data[pos + 7:pos + frame_length]
                        frames.append(frame_data)
                        pos += frame_length
                    else:
                        pos += 1
                else:
                    pos += 1
            
            if not frames:
                logger.warning("No valid AAC frames found")
                return None
            
            # Combine all frame data
            combined_data = b''.join(frames)
            
            # Create WAV from combined data
            return await self._create_wav_from_raw(combined_data, sample_rate=16000)
            
        except Exception as e:
            logger.error(f"Error in AAC fallback conversion: {e}")
            return None

    async def _convert_with_librosa(self, audio_data: bytes) -> Optional[bytes]:
        """Convert any audio format to WAV using librosa (for non-AAC formats)."""
        try:
            # Create a BytesIO buffer from the audio data
            audio_buffer = BytesIO(audio_data)
            
            # Load with librosa
            audio_array, sample_rate = librosa.load(
                audio_buffer, 
                sr=16000,  # Resample to 16kHz
                mono=True  # Convert to mono
            )
            
            # Convert to WAV bytes
            output_buffer = BytesIO()
            sf.write(output_buffer, audio_array, 16000, format='WAV', subtype='PCM_16')
            output_buffer.seek(0)
            
            return output_buffer.read()
            
        except Exception as e:
            logger.error(f"Error converting with librosa: {e}")
            return None

    async def _create_wav_from_raw(self, raw_data: bytes, sample_rate: int = 16000) -> Optional[bytes]:
        """Create a WAV file from raw audio data."""
        try:
            # Ensure data length is even (16-bit samples)
            if len(raw_data) % 2 == 1:
                raw_data += b'\x00'
            
            output = BytesIO()
            with wave.open(output, 'wb') as wav_file:
                wav_file.setnchannels(1)  # Mono
                wav_file.setsampwidth(2)  # 16-bit
                wav_file.setframerate(sample_rate)
                wav_file.writeframes(raw_data)

            output.seek(0)
            return output.read()

        except Exception as e:
            logger.error(f"Error creating WAV from raw data: {e}")
            return None

    async def _recognize_from_wav(self, wav_data: bytes) -> Optional[str]:
        """Recognize speech from WAV audio data."""
        try:
            if not wav_data or len(wav_data) < 44:  # Minimum WAV header size
                logger.warning("Invalid or empty WAV data")
                return None

            wav_buffer = BytesIO(wav_data)
            with sr.AudioFile(wav_buffer) as source:
                # Adjust for ambient noise with shorter duration for short recordings
                self.recognizer.adjust_for_ambient_noise(source, duration=0.1)
                
                # Record the audio
                audio = self.recognizer.record(source)
                
                # Try Google Speech Recognition with multiple attempts
                try:
                    text = self.recognizer.recognize_google(audio, language='en-US')
                    logger.info(f"Successfully recognized: {text}")
                    return text
                except sr.UnknownValueError:
                    # Try with different settings
                    try:
                        text = self.recognizer.recognize_google(audio, language='en-CA')
                        logger.info(f"Successfully recognized (CA): {text}")
                        return text
                    except sr.UnknownValueError:
                        logger.warning("Speech recognition could not understand audio")
                        return None
                    
        except Exception as e:
            logger.error(f"Error in WAV recognition: {e}")
            return None

    async def _process_raw_pcm(self, audio_data: bytes) -> Optional[str]:
        """Process raw PCM audio data as a last resort."""
        try:
            # Try different sample rates
            for sample_rate in [16000, 44100, 48000, 8000]:
                wav_data = await self._create_wav_from_raw(audio_data, sample_rate)
                if wav_data:
                    text = await self._recognize_from_wav(wav_data)
                    if text:
                        logger.info(f"Successfully recognized with sample rate: {sample_rate}")
                        return text
            
            return None
            
        except Exception as e:
            logger.error(f"Error processing raw PCM: {e}")
            return None

    async def _generate_answer(
        self,
        question: str,
        lesson_context: str = "",
        grade_level: int = None
    ) -> Optional[str]:
        """Generate an answer using Ollama/Gemma."""
        try:
            system_context = self._get_system_prompt(grade_level)

            prompt = f"""
{system_context}

Lesson Context: {lesson_context}
Student Question: {question}

Provide a helpful, age-appropriate answer that:
- Is easy to understand for a Grade {grade_level or 'elementary'} student
- Relates to the lesson context when possible
- Encourages further learning
- Is conversational and friendly
- Keeps the answer under 3 sentences for voice delivery
- Answer the question directly when possible

Answer:
"""

            payload = {
                "model": self.model_name,
                "prompt": prompt,
                "stream": False,
                "options": {
                    "temperature": 0.7,
                    "top_p": 0.9,
                    "max_tokens": 200
                }
            }

            async with aiohttp.ClientSession(
                timeout=aiohttp.ClientTimeout(total=60)
            ) as session:
                async with session.post(
                    f"{self.ollama_base_url}/api/generate",
                    json=payload,
                    headers={'Content-Type': 'application/json'}
                ) as response:
                    if response.status == 200:
                        result = await response.json()
                        answer = result.get('response', '').strip()
                        return self._clean_answer_for_voice(answer)
                    else:
                        logger.error(f"Ollama API returned status {response.status}")
                        return None

        except Exception as e:
            logger.error(f"Error generating answer: {e}")
            return None

    def _get_system_prompt(self, grade_level: int = None) -> str:
        """Get age-appropriate system prompt."""
        if grade_level and grade_level <= 2:
            return "You are a friendly teacher helping very young students (ages 5-7). Use simple words, be encouraging, and explain things like you're talking to a child."
        elif grade_level and grade_level <= 5:
            return "You are a helpful teacher for elementary students (ages 8-11). Be clear, patient, and encouraging in your explanations."
        elif grade_level and grade_level <= 8:
            return "You are an assistant teacher for middle school students (ages 12-14). Be informative but approachable."
        else:
            return "You are a knowledgeable teaching assistant. Provide clear, helpful explanations."

    def _clean_answer_for_voice(self, answer: str) -> str:
        """Clean up text for better voice synthesis."""
        # Remove markdown formatting
        answer = answer.replace('**', '').replace('*', '')
        answer = answer.replace('##', '').replace('#', '')

        # Remove excessive punctuation
        answer = answer.replace('...', '.')
        answer = answer.replace('..', '.')

        # Ensure proper sentence ending
        if not answer.endswith(('.', '!', '?')):
            answer += '.'

        return answer

    async def _text_to_speech(self, text: str) -> str:
        """Convert text to speech and return base64 encoded audio."""
        try:
            # Create TTS object
            tts = gTTS(text=text, lang='en', slow=False)

            # Save to in-memory buffer
            mp3_buffer = BytesIO()
            tts.write_to_fp(mp3_buffer)
            mp3_buffer.seek(0)

            # Read and encode as base64
            audio_data = mp3_buffer.read()
            base64_audio = base64.b64encode(audio_data).decode('utf-8')
            return base64_audio

        except Exception as e:
            logger.error(f"Error in text to speech: {e}")
            return ""
