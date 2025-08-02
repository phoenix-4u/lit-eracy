# File: backend/app/services/ai_service.py

import json
import logging
import time
from typing import Dict, List, Optional, Tuple
import random
import re

# Note: In production, you would use actual AI models like Gemma
# For this demo, we'll create a mock AI service that generates educational content

class AIService:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.safety_keywords = [
            "violence", "inappropriate", "harmful", "dangerous", 
            "adult", "weapon", "drug", "scary", "frightening"
        ]
        
        # Sample educational content templates
        self.lesson_templates = {
            1: {  # Grade 1
                "math": [
                    "Let's learn about numbers! Today we'll count from 1 to {number}. Can you count with me?",
                    "Fun with shapes! A circle is round like a ball. A square has 4 equal sides.",
                    "Addition is like adding toys together. If you have 2 toys and get 1 more, you have 3 toys!"
                ],
                "english": [
                    "The letter {letter} makes the sound '{sound}'. Can you think of words that start with {letter}?",
                    "Reading time! Let's read about {character} who goes on a fun adventure.",
                    "Rhyming words are fun! Cat rhymes with hat, bat, and sat!"
                ]
            },
            2: {  # Grade 2
                "math": [
                    "Let's practice addition! When we add {num1} + {num2}, we get {result}. Try some more!",
                    "Understanding place value: The number 23 has 2 tens and 3 ones.",
                    "Time to learn about time! When the big hand points to 12 and little hand points to 3, it's 3 o'clock!"
                ],
                "english": [
                    "Sentence building: A sentence needs a who (subject) and what they do (action).",
                    "Story about {animal} who learned to {action}. What do you think happened next?",
                    "Capital letters start sentences and names of special people and places."
                ]
            }
        }
        
        self.story_characters = [
            "Brave Lion Leo", "Curious Cat Whiskers", "Friendly Elephant Ellie",
            "Smart Owl Oliver", "Playful Puppy Max", "Kind Bear Benny"
        ]
        
        self.quiz_questions = {
            1: {
                "math": [
                    {
                        "question": "What comes after the number 5?",
                        "options": ["4", "6", "7", "3"],
                        "correct": 1,
                        "explanation": "6 comes after 5 when we count!"
                    },
                    {
                        "question": "How many sides does a triangle have?",
                        "options": ["2", "3", "4", "5"],
                        "correct": 1,
                        "explanation": "A triangle has 3 sides and 3 corners!"
                    }
                ],
                "english": [
                    {
                        "question": "Which letter makes the 'A' sound?",
                        "options": ["B", "A", "C", "D"],
                        "correct": 1,
                        "explanation": "The letter A makes the 'A' sound like in 'Apple'!"
                    }
                ]
            }
        }

    async def generate_content(
        self, 
        content_type: str, 
        grade_level: int, 
        subject: str, 
        topic: Optional[str] = None,
        difficulty: int = 1,
        user_preferences: Optional[Dict] = None
    ) -> Tuple[str, float, float]:
        """
        Generate educational content based on parameters
        Returns: (content_json, generation_time, safety_score)
        """
        start_time = time.time()
        
        try:
            if content_type == "lesson":
                content = self._generate_lesson(grade_level, subject, topic, difficulty)
            elif content_type == "quiz":
                content = self._generate_quiz(grade_level, subject, topic, difficulty)
            elif content_type == "story":
                content = self._generate_story(grade_level, topic, user_preferences)
            elif content_type == "activity":
                content = self._generate_activity(grade_level, subject, topic)
            else:
                raise ValueError(f"Unsupported content type: {content_type}")
            
            generation_time = time.time() - start_time
            safety_score = self._check_content_safety(content)
            
            return json.dumps(content), generation_time, safety_score
            
        except Exception as e:
            self.logger.error(f"Content generation failed: {str(e)}")
            raise

    def _generate_lesson(self, grade_level: int, subject: str, topic: str, difficulty: int) -> Dict:
        """Generate a lesson based on parameters"""
        templates = self.lesson_templates.get(grade_level, self.lesson_templates[1])
        subject_templates = templates.get(subject.lower(), templates.get("english", []))
        
        if not subject_templates:
            subject_templates = ["Let's learn about {topic}! This is an exciting subject to explore."]
        
        template = random.choice(subject_templates)
        
        # Fill in template variables
        content_text = template.format(
            number=random.randint(5, 20),
            letter=random.choice("ABCDEFGHIJK"),
            sound=random.choice(["ah", "buh", "kuh", "duh"]),
            character=random.choice(self.story_characters),
            animal=random.choice(["rabbit", "squirrel", "bird", "fox"]),
            action=random.choice(["be kind", "help friends", "share toys", "be brave"]),
            num1=random.randint(1, 10),
            num2=random.randint(1, 10),
            result=lambda: random.randint(2, 20),
            topic=topic or subject
        )
        
        return {
            "type": "lesson",
            "title": f"{subject.title()} Lesson: {topic or 'Fun Learning'}",
            "content": content_text,
            "grade_level": grade_level,
            "subject": subject,
            "activities": [
                {
                    "type": "practice",
                    "instruction": "Try this activity to practice what you learned!",
                    "points": 10
                }
            ],
            "learning_objectives": [
                f"Understand basic {subject} concepts",
                f"Apply {subject} knowledge in practice",
                "Build confidence in learning"
            ]
        }

    def _generate_quiz(self, grade_level: int, subject: str, topic: str, difficulty: int) -> Dict:
        """Generate a quiz based on parameters"""
        questions_pool = self.quiz_questions.get(grade_level, self.quiz_questions[1])
        subject_questions = questions_pool.get(subject.lower(), questions_pool.get("math", []))
        
        if not subject_questions:
            # Generate simple questions
            subject_questions = [
                {
                    "question": f"What is a fun fact about {topic or subject}?",
                    "options": ["It's interesting", "It's fun", "It's educational", "All of the above"],
                    "correct": 3,
                    "explanation": f"{topic or subject} is interesting, fun, and educational!"
                }
            ]
        
        # Select questions based on difficulty
        num_questions = min(difficulty * 2 + 1, len(subject_questions))
        selected_questions = random.sample(subject_questions, min(num_questions, len(subject_questions)))
        
        return {
            "type": "quiz",
            "title": f"{subject.title()} Quiz: {topic or 'Knowledge Check'}",
            "grade_level": grade_level,
            "subject": subject,
            "questions": selected_questions,
            "total_points": len(selected_questions) * 5,
            "time_limit": len(selected_questions) * 30  # 30 seconds per question
        }

    def _generate_story(self, grade_level: int, topic: str, user_preferences: Dict) -> Dict:
        """Generate an engaging story"""
        character = random.choice(self.story_characters)
        user_name = user_preferences.get("name", "friend") if user_preferences else "friend"
        
        story_templates = [
            f"Once upon a time, {character} met a wonderful {user_name}. Together they discovered the magic of {topic or 'learning'}. {character} taught {user_name} about being kind and curious.",
            f"In a magical forest, {character} found a special book about {topic or 'friendship'}. When {user_name} joined the adventure, they learned that the best treasures are the friends we make.",
            f"{character} was feeling sad until {user_name} showed them how to {random.choice(['be brave', 'help others', 'share happiness', 'learn new things'])}. Their friendship grew stronger every day."
        ]
        
        story_content = random.choice(story_templates)
        
        return {
            "type": "story",
            "title": f"The Adventures of {character}",
            "content": story_content,
            "grade_level": grade_level,
            "characters": [character, user_name],
            "moral": "Friendship and kindness make the world brighter",
            "reading_time": 3,
            "illustrations": [
                {"description": f"{character} smiling happily"},
                {"description": f"{character} and {user_name} playing together"},
                {"description": "A beautiful sunny day with friends"}
            ]
        }

    def _generate_activity(self, grade_level: int, subject: str, topic: str) -> Dict:
        """Generate an interactive activity"""
        activities = {
            "math": [
                {
                    "type": "counting_game",
                    "title": "Count the Objects!",
                    "instruction": "Count how many objects you see and select the right number!",
                    "objects": ["🍎", "🌟", "🚂", "🎨"],
                    "count": random.randint(3, 8)
                },
                {
                    "type": "shape_matching",
                    "title": "Match the Shapes!",
                    "instruction": "Match each shape with its name!",
                    "shapes": ["circle", "square", "triangle", "rectangle"]
                }
            ],
            "english": [
                {
                    "type": "letter_tracing",
                    "title": "Trace the Letters!",
                    "instruction": "Trace each letter carefully and say its sound!",
                    "letters": ["A", "B", "C", "D", "E"]
                },
                {
                    "type": "word_building",
                    "title": "Build Words!",
                    "instruction": "Use the letters to build simple words!",
                    "target_words": ["CAT", "DOG", "SUN", "FUN"]
                }
            ]
        }
        
        subject_activities = activities.get(subject.lower(), activities["math"])
        activity = random.choice(subject_activities)
        
        return {
            "type": "activity",
            "title": activity["title"],
            "grade_level": grade_level,
            "subject": subject,
            "activity_data": activity,
            "points_reward": 15,
            "completion_time": 5
        }

    def _check_content_safety(self, content: Dict) -> float:
        """Check if content is safe for children"""
        content_text = json.dumps(content).lower()
        
        # Check for inappropriate keywords
        safety_violations = 0
        for keyword in self.safety_keywords:
            if keyword in content_text:
                safety_violations += 1
        
        # Calculate safety score (1.0 = completely safe, 0.0 = unsafe)
        if safety_violations == 0:
            return 1.0
        else:
            return max(0.0, 1.0 - (safety_violations * 0.2))

    async def chat_with_ai(self, message: str, context: str = None) -> Tuple[str, bool, float]:
        """
        Chat with AI assistant
        Returns: (response, is_safe, confidence)
        """
        # Safety check on input
        is_safe = self._is_message_safe(message)
        if not is_safe:
            return "I'm sorry, I can't help with that. Let's talk about something fun and educational!", False, 0.9
        
        # Generate appropriate response
        responses = [
            f"That's a great question! Let me help you learn about that.",
            f"I love curious minds! Here's what I know about that topic.",
            f"What an interesting thing to ask! Let's explore this together.",
            f"You're such a smart learner! Here's a fun fact about that.",
            f"Great question! Learning new things is so exciting!"
        ]
        
        response = random.choice(responses)
        confidence = random.uniform(0.8, 0.95)
        
        return response, True, confidence

    def _is_message_safe(self, message: str) -> bool:
        """Check if user message is appropriate"""
        message_lower = message.lower()
        for keyword in self.safety_keywords:
            if keyword in message_lower:
                return False
        return True

    def get_content_recommendations(self, user_grade: int, completed_content: List[int]) -> List[Dict]:
        """Get recommended content for user"""
        recommendations = []
        
        subjects = ["math", "english", "science", "art"]
        
        for subject in subjects:
            content = {
                "id": random.randint(1000, 9999),
                "title": f"Fun {subject.title()} Lesson",
                "subject": subject,
                "grade_level": user_grade,
                "difficulty_level": random.randint(1, 3),
                "points_reward": random.randint(10, 25),
                "estimated_duration": random.randint(5, 15)
            }
            recommendations.append(content)
        
        return recommendations[:3]  # Return top 3 recommendations