from django.views.decorators.csrf import ensure_csrf_cookie

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status

import json
import anthropic

from pathlib import Path
import os
from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent.parent
load_dotenv(BASE_DIR / '.env')

api_key = os.environ.get('ANTHROPIC_API_KEY')

SCHEMA_TEMPLATE = {
    "study_plan": {
        "subject": "",
        "level": "",
        "topic": "",
        "exam_date": "",
        "test_type": "",
        "generated_date": "",
        "language": "",
        "flashcards": {
            "1": [{"question": "", "answer": ""}],
            "2": [{"question": "", "answer": ""}],
            "3": [{"question": "", "answer": ""}]
        },
        "multiple_choice": [
            {
                "question": "",
                "options": ["", "", "", ""],
                "correct_answer": ""
            }
        ],
        "days": [
            {
                "date": "",
                "focus": "",
                "tasks": {
                    "Task 1": {"description": ""},
                    "Task 2": {"description": "", "type": "Flashcards", "set": 1}
                }
            }
        ]
    }
}

SYSTEM_PROMPT = """You are an educational assistant that generates structured study plans.
You must respond with ONLY valid JSON that follows the provided schema exactly.
Do not include any explanation or text outside the JSON."""


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
- language: {language}
- generated_date: today's date

Generate relevant flashcards (sets), multiple choice questions, and a day-by-day study schedule up to the exam date.
Write all content in: {language}.
Respond with ONLY the filled JSON, no extra text."""


    client = anthropic.Anthropic(api_key=api_key)
    message = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=4096,
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": user_message}],
    )

    raw = message.content[0].text.strip()
    print(message.content)
    # Strip markdown code fences if present
    if raw.startswith("```"):
        raw = raw.split("```", 2)[1]
        if raw.startswith("json"):
            raw = raw[4:]

    study_plan = json.loads(raw)
    return Response(study_plan, status=status.HTTP_200_OK)

