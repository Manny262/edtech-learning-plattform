from django.views.decorators.csrf import ensure_csrf_cookie

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from django.db import connection as conn

import json
import anthropic
from datetime import date

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@ensure_csrf_cookie
def get_study_plan(request, study_plan_id=None):
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM get_all_study_plans(%s)', [request.user.id])

    columns = [col[0] for col in cursor.description]
    results = cursor.fetchall()
    cursor.close()
    
    study_plans = [dict(zip(columns, row)) for row in results]
        
    return Response(study_plans, status=status.HTTP_200_OK)
    