CREATE OR REPLACE PROCEDURE save_study_plan (p_data JSONB, user_id BIGINT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_study_course_id BIGINT;
    v_day JSONB;


    v_study_day_id BIGINT;
    v_task_type_id BIGINT;
    v_task RECORD;

    v_Multiple_choices_type_id BIGINT;
    v_Flashcards_type_id BIGINT;
    v_None_type_id BIGINT;

    v_Multiple_choice_type_id BIGINT;
    v_Flashcard_type_id BIGINT;
    v_Flashcard JSONB;
    v_Multiple_choice JSONB;

    v_question_id BIGINT;
BEGIN
    SELECT task_type_id INTO v_Multiple_choices_type_id FROM task_type WHERE type_name = 'Multiple_choices';
    SELECT task_type_id INTO v_Flashcards_type_id FROM task_type WHERE type_name = 'Flashcards';
    SELECT task_type_id INTO v_None_type_id FROM task_type WHERE type_name = 'None';
    


    INSERT INTO study_course(user_id, test_type_id, topic, subject, grade, exam_date, language)
    VALUES(user_id, (p_data->>'test_type_id')::INT, p_data->>'topic', p_data->>'subject', p_data->>'grade', TO_TIMESTAMP(p_data->>'exam_date', 'DD-MM-YYYY'), p_data->>'language')
    RETURNING study_course_id INTO v_study_course_id;

    
    FOR v_day IN SELECT jsonb_array_elements(p_data->'days')
    LOOP
        INSERT INTO study_day(study_course_id, focus_area, scheduled_date)
        VALUES(v_study_course_id, v_day->>'focus_area', TO_TIMESTAMP(v_day->>'scheduled_date', 'DD-MM-YYYY'))
        RETURNING study_day_id INTO v_study_day_id;
        
       FOR v_task IN SELECT * FROM jsonb_each(v_day->'tasks')
       LOOP
            CASE v_task.value->>'type'
                WHEN 'Flashcards' THEN v_task_type_id := v_Flashcards_type_id;
                WHEN 'Multiple_choices' THEN v_task_type_id := v_Multiple_choices_type_id;
            ELSE
                v_task_type_id := v_None_type_id;
            END CASE;

            INSERT INTO task(study_day_id, task_type_id, order_number, description, set_number)
            VALUES(v_study_day_id, v_task_type_id , v_task.key::int, v_task.value->>'description', (v_task.value->'set_number')::int);
        END LOOP;
    END LOOP;

    SELECT question_type_id INTO v_Flashcard_type_id FROM question_type WHERE type_name = 'Flashcard';
    SELECT question_type_id INTO v_Multiple_choice_type_id FROM question_type WHERE type_name = 'Multiple_choice';

    FOR v_Flashcard IN SELECT jsonb_array_elements(p_data->'flashcards')
    LOOP  
        INSERT INTO question(study_course_id, question_type_id, set_number, question_text)
        VALUES(v_study_course_id, v_Flashcard_type_id, (v_Flashcard->>'set_number')::INT, v_Flashcard->>'question_text')
        RETURNING question_id INTO v_question_id;

        INSERT INTO answer(question_id, answer_text)
        VALUES(v_question_id, v_Flashcard->>'answer_text');
    END LOOP;

    FOR v_Multiple_choice  IN SELECT jsonb_array_elements(p_data->'multiple_choice')
    LOOP         
        INSERT INTO question(study_course_id, question_type_id, set_number, question_text)
        VALUES(v_study_course_id, v_Multiple_choice_type_id, (v_Multiple_choice->>'set_number')::INT, v_Multiple_choice->>'question_text')
        RETURNING question_id INTO v_question_id;

        INSERT INTO multiple_choice_option(question_id, correct_answer_index, options_json_array)
        VALUES(v_question_id, (v_Multiple_choice->>'correct_answer_index')::INT, v_Multiple_choice->'options');
    END LOOP;
END;
$$;

DROP PROCEDURE mark_questions(jsonb);
CREATE OR REPLACE PROCEDURE mark_questions(p_data JSONB) --questions_array JSONB
LANGUAGE plpgsql
AS $$
DECLARE
    q JSONB;
BEGIN 
	FOR q IN SELECT jsonb_array_elements(p_data->'questions_array')
	LOOP
		UPDATE question qt		
		SET completed = TRUE
		WHERE q->'question_id' = qt.question_id;
	END LOOP; 
END;
$$;




CALL mark_questions('[{"question_id":1,"set_number":1,"question_text":"Hva er en velferdsstat?","completed":false,"answer_text":"En velferdsstat er et samfunn hvor staten tar ansvar for innbyggernes velferd gjennom offentlige tjenester som helsevesen, utdanning, trygd og sosiale støtteordninger."},{"question_id":2,"set_number":1,"question_text":"Hva er de tre hovedmodellene for velferdsstater?","completed":false,"answer_text":"De tre hovedmodellene er: Den universelle/nordiske modellen, den konservative/kontinentaleuropeiske modellen, og den liberale/angloamerikanske modellen."},{"question_id":3,"set_number":1,"question_text":"Hva kjennetegner den nordiske velferdsmodellen?","completed":false,"answer_text":"Den nordiske modellen kjennetegnes av universelle rettigheter, høy offentlig finansiering gjennom skatt, generøse velferdsordninger og likhet mellom kjønn og sosiale grupper."},{"question_id":4,"set_number":1,"question_text":"Når ble grunnlaget for den norske velferdsstaten lagt?","completed":false,"answer_text":"Grunnlaget ble hovedsakelig lagt etter andre verdenskrig, fra 1945 og utover, med kraftig utbygging på 1960- og 1970-tallet."},{"question_id":5,"set_number":1,"question_text":"Hva er NAV?","completed":false,"answer_text":"NAV (Nye arbeids- og velferdsetaten) er en statlig etat som forvalter arbeidsmarkedstiltak, pensjon, sykepenger, dagpenger og andre trygdeordninger i Norge."}]')
