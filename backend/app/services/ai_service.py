# File: backend/app/services/ai_service.py

import asyncio
import json
import logging
import sys
from typing import Dict, Any, Optional
import aiohttp

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class AIService:
    def __init__(self, ollama_url: str = "http://localhost:11434", model: str = "gemma3n:e2b"):
        self.ollama_base_url = ollama_url
        self.model_name = model
    
    def _get_grade_appropriate_prompt(self, lesson_content: str, grade_level: int = None) -> str:
        """Generate age-appropriate prompts based on grade level."""
        
        # Define grade-specific guidelines
        if grade_level is None or grade_level <= 2:
            complexity = "very simple"
            skills = "basic counting, single-digit addition/subtraction, shapes, colors"
            instructions = "Use simple words, pictures, and hands-on activities"
        elif grade_level <= 5:
            complexity = "elementary level"
            skills = "basic math operations, simple reading, basic science concepts"
            instructions = "Use clear language and step-by-step instructions"
        elif grade_level <= 8:
            complexity = "middle school level"  
            skills = "fractions, multiplication, reading comprehension, basic algebra"
            instructions = "Include problem-solving and critical thinking"
        else:
            complexity = "high school level"
            skills = "advanced math, complex reading, scientific analysis"
            instructions = "Include analytical thinking and research components"

        return f"""
        IMPORTANT: Create a task for Grade {grade_level or 1} students only.
        
        Lesson Content: "{lesson_content}"
        Student Grade Level: {grade_level or 1}
        Complexity Required: {complexity}
        Appropriate Skills: {skills}
        
        Generate an educational task in JSON format with exactly these fields:
        {{
            "title": "A clear, engaging task title (max 50 characters)",
            "description": "Detailed task description with specific steps for Grade {grade_level or 1} students"
        }}
        
        CRITICAL REQUIREMENTS:
        - Content must be appropriate for Grade {grade_level or 1} students
        - {instructions}
        - If this is math, use only concepts a Grade {grade_level or 1} student would understand
        - NO advanced concepts like quadratic equations, calculus, or complex algebra for young grades
        - Make it fun, engaging, and achievable for the specified age group
        
        For Grade 1-2 Math: Focus on counting, number recognition, basic shapes, simple addition/subtraction
        For Grade 1-2 Reading: Focus on letter sounds, simple words, picture books
        
        Return only valid JSON, no additional text.
        """
    
    async def generate_task_with_ollama(self, lesson_content: str, grade_level: int = None) -> Optional[Dict[str, Any]]:
        """Generate a task using Ollama based on lesson content."""
        try:
            prompt = self._get_grade_appropriate_prompt(lesson_content, grade_level)
            
            payload = {
                "model": self.model_name,
                "prompt": prompt,
                "stream": False,
                "format": "json",
                "options": {
                    "temperature": 0.5,  # Lower temperature for more consistent, appropriate content
                    "top_p": 0.8,
                    "top_k": 40
                }
            }
            
            async with aiohttp.ClientSession(
                timeout=aiohttp.ClientTimeout(total=120, connect=10, sock_read=120)
            ) as session:
                async with session.post(
                    f"{self.ollama_base_url}/api/generate",
                    json=payload,
                    headers={'Content-Type': 'application/json'}
                ) as response:
                    if response.status == 200:
                        result = await response.json()
                        response_text = result.get('response', '').strip()
                        
                        try:
                            task_data = json.loads(response_text)
                            
                            # Validate content is appropriate for grade level
                            title = task_data.get("title", "")
                            description = task_data.get("description", "")
                            
                            # Check for inappropriate content for young grades
                            if grade_level and grade_level <= 5:
                                inappropriate_terms = [
                                    "quadratic", "equation", "algebra", "calculus", "polynomial",
                                    "derivative", "integral", "logarithm", "trigonometry", "matrix"
                                ]
                                
                                content_lower = (title + " " + description).lower()
                                if any(term in content_lower for term in inappropriate_terms):
                                    logger.warning(f"Generated inappropriate content for Grade {grade_level}, using fallback")
                                    return self.generate_fallback_task(lesson_content, grade_level)
                            
                            return {
                                "title": title[:50],  # Ensure max length
                                "description": description
                            }
                            
                        except json.JSONDecodeError as e:
                            logger.error(f"Failed to parse AI response as JSON: {response_text}, Error: {e}")
                            return self.generate_fallback_task(lesson_content, grade_level)
                    else:
                        logger.error(f"Ollama API returned status {response.status}")
                        return None
                        
        except asyncio.TimeoutError:
            logger.error("Ollama request timed out")
            return None
        except Exception as e:
            logger.error(f"Error generating task with Ollama: {e}")
            return None
    
    def generate_fallback_task(self, lesson_content: str, grade_level: int = None) -> Dict[str, Any]:
        """Generate a grade-appropriate fallback task when AI fails."""
        
        # Grade-specific fallback tasks
        if grade_level and grade_level <= 2:
            if "math" in lesson_content.lower():
                return {
                    "title": "Count and Add Fun!",
                    "description": f"Practice counting from 1 to 10. Use your fingers or toys to count objects. Try adding: 2 + 3 = ? Draw the answer with pictures or use real objects like blocks or crayons."
                }
            else:
                return {
                    "title": "Learning Fun Activity",
                    "description": f"Learn about '{lesson_content[:30]}...' by drawing pictures, asking questions, and talking about what you learned with your teacher or family."
                }
        
        elif grade_level and grade_level <= 5:
            return {
                "title": f"Grade {grade_level} Practice",
                "description": f"Complete practice activities about '{lesson_content[:50]}...'. Work through examples, solve simple problems, and explain your thinking to someone else."
            }
        
        else:
            return {
                "title": f"Learning Activity: {lesson_content[:25]}...",
                "description": f"Study and practice the concepts from '{lesson_content[:50]}...'. Complete exercises and review the key points covered."
            }

    async def test_connection(self) -> bool:
        """Test if Ollama service is accessible."""
        try:
            async with aiohttp.ClientSession() as session:
                async with session.get(
                    f"{self.ollama_base_url}/api/tags",
                    timeout=aiohttp.ClientTimeout(total=5)
                ) as response:
                    return response.status == 200
        except Exception as e:
            logger.error(f"Failed to connect to Ollama: {e}")
            return False

# Standalone script functionality
async def main():
    """Main function for standalone script execution."""
    print("🤖 AI Service Standalone Test")
    print("=" * 40)
    
    ai_service = AIService()
    
    print("Testing Ollama connection...")
    is_connected = await ai_service.test_connection()
    
    if not is_connected:
        print("❌ Failed to connect to Ollama service.")
        return
    
    print("✅ Connected to Ollama service\n")
    
    # Test with different grade levels
    test_cases = [
        ("Basic counting and number recognition", 1),
        ("Addition and subtraction with numbers 1-20", 2),
        ("Multiplication tables and word problems", 4),
        ("Introduction to fractions and decimals", 6)
    ]
    
    for lesson_content, grade in test_cases:
        print(f"📚 Testing Grade {grade}: {lesson_content}")
        
        task = await ai_service.generate_task_with_ollama(lesson_content, grade)
        
        if task:
            print(f"✅ Generated appropriate task:")
            print(f"   📌 Title: {task['title']}")
            print(f"   📝 Description: {task['description'][:100]}...")
        else:
            fallback = ai_service.generate_fallback_task(lesson_content, grade)
            print(f"⚠️ Using fallback:")
            print(f"   📌 Title: {fallback['title']}")
        print("-" * 40)

def run_sync_test():
    """Synchronous wrapper for the async main function."""
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n👋 Script interrupted by user.")

if __name__ == "__main__":
    run_sync_test()
