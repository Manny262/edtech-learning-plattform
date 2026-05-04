-- DROP FUNCTION get_all_study_plans(bigint);

CREATE OR REPLACE FUNCTION get_all_study_plans(p_user_id BIGINT)
RETURNS TABLE(study_course_id BIGINT, topic VARCHAR, subject VARCHAR, grade VARCHAR, exam_date TIMESTAMPTZ, created_at TIMESTAMPTZ, test_type VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT sc.study_course_id, sc.topic, sc.subject, sc.grade, sc.exam_date, sc.created_at, tt.name AS test_type
    FROM study_course sc
    LEFT JOIN test_type tt USING(test_type_id)
    WHERE sc.user_id = p_user_id;
END;
$$; 

-- DROP FUNCTION get_study_timeline(bigint, bigint);

CREATE OR REPLACE FUNCTION get_study_timeline(p_study_course_id BIGINT, p_user_id BIGINT)
RETURNS TABLE(focus_area VARCHAR, scheduled_date DATE, order_number INTEGER, description TEXT, set_number INTEGER, completed BOOLEAN, type_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY 
	SELECT sd.focus_area, sd.scheduled_date, t.order_number, t.description, t.set_number, t.completed, tt.type_name
	FROM study_course
	INNER JOIN study_day sd USING(study_course_id)
	LEFT JOIN task t USING(study_day_id)
	LEFT JOIN task_type tt USING(task_type_id)
	WHERE study_course_id = p_study_course_id and user_id = p_user_id;
END;
$$;