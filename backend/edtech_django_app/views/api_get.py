from django.views.decorators.csrf import ensure_csrf_cookie

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from django.db import connection as conn


import json

from itertools import groupby
from operator import itemgetter

def clean_task(task):
        redundant = ['scheduled_date', 'focus_area']
        return {k: v for k, v in task.items() if k not in redundant}
            
def db_query(query, params):
    cursor = conn.cursor()
    cursor.execute(query, params)
    columns = [col[0] for col in cursor.description]
    results = cursor.fetchall()
    cursor.close()
    
    return [dict(zip(columns, row)) for row in results]

@api_view(['GET'])
@permission_classes([IsAuthenticated])
@ensure_csrf_cookie
def get_study_plan(request, study_course_id=None):
    if study_course_id:
        data = db_query('SELECT * FROM get_study_timeline(%s, %s)',[study_course_id, request.user.id])
       
        sorted_data = sorted(data, key=itemgetter('scheduled_date'))
        grouped = {k: list(g) for k, g in groupby(sorted_data, key=itemgetter('scheduled_date')) }

        result = [
            {"scheduled_date": date,
                "focus_area": tasks[0]['focus_area'],
                "tasks": [clean_task(task) for task in tasks ]
                }
            for date, tasks in grouped.items()
        ]
    else:
        result = db_query('SELECT * FROM get_all_study_plans(%s)', [request.user.id,])
 
    return Response(result, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
@ensure_csrf_cookie
def get_flashcards(request, set):
    set_params = set.split('-')
    print('😊', int(set_params[1]))
    result = db_query('SELECT * FROM get_flashcards(%s,%s,%s)', [int(set_params[0]), request.user.id, int(set_params[1])])
    
    return Response(result, status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
@ensure_csrf_cookie
def get_multiple_choices(request, set):
    set_params = set.split('-')
    result = db_query('SELECT * FROM get_multiple_choices(%s,%s,%s)', [int(set_params[0]), request.user.id, int(set_params[1])])

    return Response(result, status=status.HTTP_200_OK)
    