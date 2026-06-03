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

CREATE OR REPLACE FUNCTION get_flashcards(p_study_course_id BIGINT, p_user_id BIGINT, p_set_number INTEGER)
RETURNS TABLE(question_id BIGINT, set_number INTEGER, question_text TEXT, completed BOOLEAN, answer_text TEXT)
LANGUAGE plpgsql
AS $$
-- DECLARE
	-- p_flashcard_type_id BIGINT;
BEGIN
	RETURN QUERY
	-- SELECT question_type_id INTO p_flashcard_type_id FROM question_type WHERE type_name = 'Flascard';

	
	SELECT q.question_id, q.set_number, q.question_text, q.completed, a.answer_text
	FROM study_course sc
	INNER JOIN question q ON q.study_course_id = p_study_course_id
		AND q.set_number = p_set_number 
		AND q.question_type_id = 1 -- Flashcard = 1
	INNER JOIN answer a USING(question_id)
	WHERE sc.study_course_id = p_study_course_id AND sc.user_id = p_user_id;
END;
$$;

CREATE OR REPLACE FUNCTION get_multiple_choices(p_study_course_id BIGINT, p_user_id BIGINT, p_set_number INTEGER)
RETURNS TABLE(question_id BIGINT, set_number INTEGER, question_text TEXT, completed BOOLEAN, correct_answer_index INTEGER, options_json_array JSONB)
LANGUAGE plpgsql
AS $$
BEGIN 
	RETURN QUERY
	SELECT q.question_id, q.set_number, q.question_text, q.completed, mco.correct_answer_index, mco.options_json_array JSONB
	FROM study_course sc
	INNER JOIN question q ON q.study_course_id = p_study_course_id
		AND q.set_number = p_set_number
		AND q.question_type_id = 2 -- Multiple Choice = 2
	INNER JOIN Multiple_choice_option mco USING(question_id)
	WHERE sc.study_course_id = p_study_course_id AND sc.user_id = p_user_id;
	-- GROUP BY q.question_id, q.set_number, q.question_text, q.completed, q.correct_answer_index;
END;
$$;

CREATE OR REPLACE FUNCTION check_user_study_course(p_study_course_id BIGINT)
RETURNS TABLE (study_course_id BIGINT, user_id BIGINT)
LANGUAGE plpgsql
AS $$
BEGIN 
	RETURN QUERY
	SELECT sc.study_course_id, sc.user_id
	FROM study_course sc
	WHERE sc.study_course_id = p_study_course_id;
END; 
$$

-- SELECT * FROM get_flashcards(20,1,1);
	
-- SELECT * FROM question
