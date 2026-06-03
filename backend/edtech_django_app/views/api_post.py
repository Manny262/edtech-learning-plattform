from django.views.decorators.csrf import ensure_csrf_cookie

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status

from .helpers import one_row_db_query, db_procedure_call

import json

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@ensure_csrf_cookie
def mark_question_as_completed(request):
    questions_arr = request.POST['completed_questions_arr']
    study_course_id = request.POST['study_course_id']
    user_id = request.user.id

    relation_check = one_row_db_query('SELECT * FROM check_user_study_course(%s)', [study_course_id] )
    print(relation_check)
    
    if relation_check['user_id'] == user_id:
        
        db_procedure_call("CALL mark_questions(%s)",[json.dumps(questions_arr)])
        return Response(status=status.HTTP_200_OK)
    else: return Response(status=status.HTTP_401_UNAUTHORIZED)
            
    