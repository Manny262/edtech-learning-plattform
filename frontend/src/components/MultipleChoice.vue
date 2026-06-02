<template>
    <div class="ParentActiveMultipleChoice">
        <span class="question-text">{{ activeQuestion.question_text }}</span>
        <div class="options-list">
            <button
                v-for="(option, index) in activeQuestion.options_json_array"
                :key="index"
                :class="getOptionClass(index)"
                :disabled="answered"
                @click="selectOption(index)"
            >
                {{ option }}
            </button>
        </div>
        <div class="ParentNext" v-if="answered">
            <span v-if="selectedIndex === activeQuestion.correct_answer_index">✅ Riktig!</span>
            <span v-else>❌ Feil! Riktig svar: {{ activeQuestion.options_json_array[activeQuestion.correct_answer_index] }}</span>
            <button @click="nextQuestion()">Neste</button>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'MultipleChoice',
    props: {
        setParams: {
            type: String,
            required: true
        }
    },
    data() {
        return {
            set: [],
            activeQuestion: {},
            activeQuestionIndex: 0,
            selectedIndex: null,
            answered: false,
        }
    },
    mounted() {
        this.getMultipleChoices(this.setParams)
    },
    methods: {
        getMultipleChoices(setParams) {
            console.log(setParams)
            axios.get(`/api/get_multiple_choices/${setParams}/`)
            .then(response => {
                this.set = response.data.map(q => ({
                    ...q,
                    options_json_array: typeof q.options_json_array === 'string'
                        ? JSON.parse(q.options_json_array)
                        : q.options_json_array
                }))
                console.log(this.set)

                localStorage.setItem('question_set_param', setParams)
                localStorage.setItem('questions_arr', JSON.stringify(this.set))
                localStorage.removeItem('completed_questions_arr')

                this.activeQuestion = this.set[0]

                console.log('active question:', this.activeQuestion)
            })
            .catch(error => {
                console.error(error)
            })
        },
        selectOption(index) {
            this.selectedIndex = index
            this.answered = true

            let arr = JSON.parse(localStorage.getItem('completed_questions_arr')) || []
            if(index === this.activeQuestion.correct_answer_index){
                arr.push(this.activeQuestion)
                localStorage.setItem('completed_questions_arr', JSON.stringify(arr))
            }
        },
        getOptionClass(index) {
            if(!this.answered) return ''
            if(index === this.activeQuestion.correct_answer_index) return 'correct'
            if(index === this.selectedIndex) return 'wrong'
            return ''
        },
        nextQuestion() {
            const current_index = this.activeQuestionIndex += 1
            this.activeQuestion = this.set[current_index]
            this.selectedIndex = null
            this.answered = false
        }
    }
}
</script>
