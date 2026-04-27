CREATE OR REPLACE PROCEDURE save_study_plan (p_data JSONB, user_id BIGINT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_study_course_id BIGINT;
    v_day JSONB;
    v_study_day_id BIGINT;
BEGIN
    INSERT INTO study_course(user_id, test_type_id, topic, subject, grade, exam_date, language)
    VALUES(user_id, (p_data->>'test_type_id')::NUMERIC, p_data->>'topic', p_data->>'subject', p_data->>'grade', p_data->>'exam_date', p_data->>'language')
    RETURNING study_course_id INTO v_study_course_id;

    FOR v_day IN SELECT jsonb_array_elements(p_data->'study_plan'->'days')
    LOOP
        INSERT INTO study_day(study_course_id, focus_area, scheduled_date)
        VALUES(v_study_course_id, v_day->>'focus_area', v_day->>'scheduled_date');
        RETURNING study_day_id INTO v_study_day_id;
        
        FOR task in jsonb_each(v_day->'tasks')
        LOOP
            -- Continue here
    END LOOP;
END;
$$;