-- Set German date format (DD.MM.YYYY HH:MM:SS)
SET DateStyle TO 'German';

-- Test types for categorizing study plans
CREATE TABLE test_type(
	test_type_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(200) NOT NULL,
	description TEXT
);

-- Task types for categorizing daily tasks
CREATE TABLE task_type(
	task_type_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	type_name VARCHAR(200) NOT NULL,
	description TEXT
);

-- Question types for categorizing questions
CREATE TABLE question_type(
	question_type_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	type_name VARCHAR(200) NOT NULL,
	description TEXT
);

-- Main study course/plan
CREATE TABLE study_course(
	study_course_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id BIGINT NOT NULL REFERENCES public.auth_user(id) ON DELETE CASCADE,
	test_type_id BIGINT NOT NULL REFERENCES test_type(test_type_id) ON DELETE RESTRICT,
	topic VARCHAR(200) NOT NULL,
	subject VARCHAR(200) NOT NULL,
	grade VARCHAR(200) NOT NULL,
	exam_date TIMESTAMPTZ NOT NULL,
	-- initial_prompt TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_study_course_user_id ON study_course(user_id);
CREATE INDEX idx_study_course_exam_date ON study_course(exam_date);

-- Add missing language column to study_course
ALTER TABLE study_course ADD COLUMN language VARCHAR(100) NOT NULL DEFAULT 'English';

-- Files associated with study courses
CREATE TABLE file(
	file_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	study_course_id BIGINT NOT NULL REFERENCES study_course(study_course_id) ON DELETE CASCADE,
	file_name VARCHAR(255) NOT NULL,
	file_path VARCHAR(500) NOT NULL,
	file_size BIGINT NOT NULL CHECK (file_size > 0),
	file_type VARCHAR(100) NOT NULL,
	description TEXT,
	uploaded_by BIGINT NOT NULL REFERENCES public.auth_user(id) ON DELETE RESTRICT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_file_study_course_id ON file(study_course_id);
CREATE INDEX idx_file_uploaded_by ON file(uploaded_by);
CREATE INDEX idx_file_created_at ON file(created_at);

-- Daily study schedule breakdown
CREATE TABLE study_day(
	study_day_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	study_course_id BIGINT NOT NULL REFERENCES study_course(study_course_id) ON DELETE CASCADE,
	focus_area VARCHAR(400) NOT NULL,
	scheduled_date DATE NOT NULL
);

CREATE INDEX idx_study_day_study_course_id ON study_day(study_course_id);
CREATE INDEX idx_study_day_scheduled_date ON study_day(scheduled_date);

-- Daily tasks within study days
CREATE TABLE task(
	task_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	study_day_id BIGINT NOT NULL REFERENCES study_day(study_day_id) ON DELETE CASCADE,
	task_type_id BIGINT NOT NULL REFERENCES task_type(task_type_id) ON DELETE RESTRICT,
	order_number INTEGER,
	description TEXT NOT NULL,
	set_number INTEGER,
	completed BOOLEAN NOT NULL DEFAULT FALSE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_task_study_day_id ON task(study_day_id);
CREATE INDEX idx_task_task_type_id ON task(task_type_id);
CREATE INDEX idx_task_completed ON task(completed);

-- Questions within tasks
CREATE TABLE question(
	question_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	study_course_id BIGINT NOT NULL REFERENCES study_course(study_course_id) ON DELETE CASCADE,
	question_type_id BIGINT NOT NULL REFERENCES question_type(question_type_id) ON DELETE RESTRICT,
	set_number INTEGER NOT NULL;
	question_text TEXT NOT NULL,
	completed BOOLEAN NOT NULL DEFAULT FALSE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_question_task_id ON question(task_id);
CREATE INDEX idx_question_question_type_id ON question(question_type_id);

-- Answers to questions
CREATE TABLE answer(
	answer_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	question_id BIGINT NOT NULL REFERENCES question(question_id) ON DELETE CASCADE,
	answer_text TEXT NOT NULL,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_answer_question_id ON answer(question_id);

-- Multiple choice options for questions
CREATE TABLE multiple_choice_option(
	multiple_choice_option_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	question_id BIGINT NOT NULL REFERENCES question(question_id) ON DELETE CASCADE,
	correct_answer_index INTEGER NOT NULL CHECK (correct_answer_index >= 0),
	options_json_array JSONB NOT NULL
);

CREATE INDEX idx_multiple_choice_option_question_id ON multiple_choice_option(question_id);

-- Insert question types
INSERT INTO question_type (type_name, description) VALUES
('Flashcard', 'Question answered with flashcard format'),
('Multiple_choice', 'Question with multiple choice options');

-- Insert task types
INSERT INTO task_type (type_name, description) VALUES
('Flashcards', 'Task to practice flashcard questions'),
('Multiple_choices', 'Task to practice multiple choice questions'),
('None', 'No specified type');

-- Insert test types (Norwegian)
INSERT INTO test_type (name, description) VALUES
('Skriftlig prøve', 'Written test examination'),
('Fagsamtale', 'Oral exam discussion'),
('Eksamen', 'Final examination');

-- Questions belong to a study course, not a specific task
-- ALTER TABLE question
--     DROP COLUMN task_id,
--     ADD COLUMN study_course_id BIGINT NOT NULL REFERENCES study_course(study_course_id) ON DELETE CASCADE,
--     ADD COLUMN set_number INTEGER NOT NULL;

CREATE INDEX idx_question_study_course_id ON question(study_course_id);
CREATE INDEX idx_question_set_number ON question(set_number);

