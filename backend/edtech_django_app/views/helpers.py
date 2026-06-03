from django.db import connection as conn
from rest_framework.response import Response
from rest_framework import status
def db_query(query, params):
    cursor = conn.cursor()
    cursor.execute(query, params)
    columns = [col[0] for col in cursor.description]
    results = cursor.fetchall()
    cursor.close()
    
    return [dict(zip(columns, row)) for row in results]

def db_procedure_call(query, params):
    with conn.cursor() as cursor:
        cursor.execute(query, params)
    return Response(status=status.HTTP_200_OK)
def one_row_db_query(query, params):
    cursor = conn.cursor()
    cursor.execute(query, params)
    columns = [col[0] for col in cursor.description]
    results = cursor.fetchone()
    cursor.close()
    
    return dict(zip(columns, results)) if results else None