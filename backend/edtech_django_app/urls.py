from django.urls import path
from edtech_django_app.views.api_study_generator import generate_study_plan, save_study_plan
from edtech_django_app.views.api_get import get_study_plan, get_flashcards, get_multiple_choices
from edtech_django_app.views.api_post import mark_question_as_completed

urlpatterns = [
    path('study-plan/generate/', generate_study_plan, name='generate_study_plan'),
    path('study-plan/save/', save_study_plan, name='save_study_plan'),
    path('study-plan/', get_study_plan, name='get_studyplan'),
    path('study-plan/<int:study_course_id>/', get_study_plan, name='get_studyplan_by_id'),

    path('get_flashcards/<str:set>/', get_flashcards, name='get_flashcards'),
    path('get_multiple_choices/<str:set>/', get_multiple_choices, name='get_multiple_choices'),
    
    path('mark_question_as_completed', mark_question_as_completed, name='mark_question_as_completed')
]
