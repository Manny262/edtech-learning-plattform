from django.urls import path
from edtech_django_app.views.api_study_generator import generate_study_plan, save_study_plan
from edtech_django_app.views.api_get import get_study_plan

urlpatterns = [
    path('study-plan/generate/', generate_study_plan, name='generate_study_plan'),
    path('study-plan/save/', save_study_plan, name='save_study_plan'),
    path('study-plan/', get_study_plan, name='get_studyplan'),
    path('study-plan/<int:study_plan_id>/', get_study_plan, name='get_studyplan_by_id'),
]
