CREATE OR REPLACE FUNCTION get_all_study_plans(user_id BIGINT)
RETURNS TABLE(study_course_id BIGINT, topic TEXT, subject TEXT, grade TEXT, exam_date TIMESTAMPTZ, created_at TIMESTAMPTZ, test_type TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT sc.study_course_id, sc.topic, sc.subject, sc.grade, sc.exam_date, sc.created_at, tt.name AS test_type
    FROM study_course sc
    LEFT JOIN test_type tt ON sc.test_type_id = tt.test_type_id
    WHERE sc.user_id = $1;
END;
$$; 