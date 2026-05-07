from django.views.decorators.csrf import ensure_csrf_cookie

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from django.db import connection as conn
from django.core.cache import cache

import json
import anthropic
from datetime import date

from pathlib import Path
import os
from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent.parent
load_dotenv(BASE_DIR / '.env')

api_key = os.environ.get('ANTHROPIC_API_KEY')

models = ['claude-sonnet-4-5', 'claude-haiku-4-5']
cache.set('current_model', 'claude-sonnet-4-5')


SCHEMA_TEMPLATE = {
    "study_plan": {
        "subject": "",
        "grade": "",
        "topic": "",
        "exam_date": "",
        "test_type": "",
        "test_type_id": "",
        "generated_date": "",
        "language": "",
        "flashcards": [
            {"question_text": "", "answer_text": "", "set_number": 1}
        ],
        "multiple_choice": [
            {
                "question_text": "",
                "options": ["", "", "", ""],
                "correct_answer_index": 0,
                "set_number": 1
            }
        ],
        "days": [
            {
                "scheduled_date": "",
                "focus_area": "",
                "tasks": {
                    "1": {"description": ""},
                    "2": {"description": "", "type": "Flashcards", "set_number": 1},
                    "3": {"description": "", "type": "Multiple_choices", "set_number": 2}
                }
            }
        ]
    }
}

SYSTEM_PROMPT = """You are an educational assistant that generates structured study plans.
You must respond with ONLY valid JSON that follows the provided schema exactly.
Do not include any explanation or text outside the JSON.

Rules:
- flashcards is a flat list. Each item must include "type": "Flashcards", a "set_number" (1, 2, or 3), "question_text", and "answer_text". Distribute questions evenly across sets.
- multiple_choice is a flat list. Each item must include "type": "Multiple_choices" and a "set_number" (1, 2, or 3) distributing questions evenly across sets.
- Each study day task that practices flashcards must have "type": "Flashcards" and "set_number" matching one of the flashcard sets.
- Each study day task that practices multiple choice must have "type": "Multiple_choices" and "set_number" matching a multiple choice set.
- Tasks with no quiz component have only a "description" field.
- All dates must be in Format (DD-MM-YYYY).
- test_type_id must be the integer provided, not a string."""


def call_anthropic(SYSTEM_PROMPT, user_message):
    try:
        current_model = cache.get('current_model')
        print('Current Model', current_model)
        
        client = anthropic.Anthropic(api_key=api_key)
        message = client.messages.create(
            model=current_model,
            max_tokens=8096,
            system=SYSTEM_PROMPT,
            messages=[{"role": "user", "content": user_message}],
        )
        return message
    except anthropic.APIConnectionError as e:
        if e.status_code == 500:
            print(f'status 500 error for: {current_model}')
            
            cache.set('model_status500', [current_model])
            
            for model in models:
                if model not in cache.get('model_status500'):
                    cache.set('current_model', model)
            
            return call_anthropic(SYSTEM_PROMPT, user_message)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@ensure_csrf_cookie
def generate_study_plan(request):
    subject   = request.POST['subject']
    level     = request.POST['level']
    topic     = request.POST['topic']
    exam_date = request.POST['exam_date']
    test_type = request.POST['test_type']
    language  = request.POST['language']
    

    match test_type:
        case 'Skriftlig prøve':
            test_type_id = 1
        case 'Fagsamtale':
            test_type_id = 2
        case 'Eksamen':
            test_type_id = 3
    
    print(subject, level, topic, exam_date, test_type, language)
    if not all([subject, level, topic, exam_date, test_type, language]):
        return Response(
            {"error": "all"},
            status=status.HTTP_400_BAD_REQUEST
        )

    user_message = f"""Generate a study plan as JSON using this exact schema:

{json.dumps(SCHEMA_TEMPLATE, indent=2)}

Fill in the schema with the following details:
- subject: {subject}
- level: {level}
- topic: {topic}
- exam_date: {exam_date}
- test_type: {test_type}
- test_type_id: {test_type_id}
- language: {language}
- generated_date: {date.today().isoformat()}

Generate relevant flashcards (sets), multiple choice questions, and a day-by-day study schedule up to the exam date from the generated date.
Write all content in: {language}.
Respond with ONLY the filled JSON, no extra text."""

    message = call_anthropic(SYSTEM_PROMPT, user_message)
    if message.stop_reason == "max_tokens":
        return Response(
            {"error": "Response was truncated. Try a shorter topic or date range."},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )
        
    raw = message.content[0].text.strip()
            
    # Strip markdown code fences if present
    if raw.startswith("```"):
        raw = raw.split("```", 2)[1]
        if raw.startswith("json"):
            raw = raw[4:]

    try:
        study_plan = json.loads(raw)
    except json.JSONDecodeError as e:
        return Response(
            {"error": f"Failed to parse study plan: {str(e)}"},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

    return Response(study_plan, status=status.HTTP_200_OK)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@ensure_csrf_cookie
def save_study_plan(request):
    data = json.loads(request.body)
    study_plan = data.get('study_plan')
       
    try:
        with conn.cursor() as cursor:
            cursor.execute("CALL save_study_plan(%s::jsonb, %s)", [json.dumps(study_plan), request.user.id])
        return Response(status=200)
    except Exception as e:
        print(str(e))
        return Response({"error": str(e)}, status=500)