<template>
    <div class="ParentActiveFlashCard">
        <span>{{ SideType }}: {{ SideDisplay }}</span>
        <button id="showOtherSide" @click="flipCard()"> vis {{ otherSide }}</button>
        <div class="ParentNext" v-if="SideType === 'svar'">
            <button @click="nextCard(false)">❌</button>
            <button @click="nextCard(true)">✅</button>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    // Spørsmål = Question, Svar = Answer

    name: 'FlashCard',
    props: {
        setParams: {
            type: String,
            required: true
        }
    },
    data() {
        return {
            set: [],
            activeCard: {},
            activeCardIndex: 0,
            SideType: 'spørsmål',
            SideDisplay: '',
            otherSide: 'svar',
        }
    },
    mounted() {
        this.getFlashCards(this.setParams)
    },
    methods: {
        getFlashCards(setParams) {
            console.log(setParams)
            axios.get(`/api/get_flashcards/${setParams}/`)
            .then(response => {
                this.set = response.data
                console.log(this.set)

                localStorage.setItem('question_set_param', setParams)
                localStorage.setItem('questions_arr', JSON.stringify(this.set))
                localStorage.removeItem('completed_questions_arr')

                this.activeCard = this.set[0]
                this.SideDisplay = this.activeCard.question_text

                console.log('active card:', this.activeCard)
            })
            .catch(error => {
                console.error(error)
            })
        },
        flipCard() {
            if(this.SideType === 'spørsmål'){
                this.otherSide = this.SideType
                this.SideType = 'svar'
                this.SideDisplay = this.activeCard.answer_text
            } else {
                this.otherSide = this.SideType
                this.SideType = 'spørsmål'
                this.SideDisplay = this.activeCard.question_text
            }
        },
        nextCard(boolean) {
            const current_index = this.activeCardIndex += 1
            let arr = JSON.parse(localStorage.getItem('completed_questions_arr')) || []
            if(boolean){
                arr.push(this.activeCard)
                localStorage.setItem('completed_questions_arr', JSON.stringify(arr))
                if (arr.length >= 3){
                    this.saveCompletedQuestions()
                } 
            }

            this.activeCard = this.set[current_index]

            this.otherSide = this.SideType
            this.SideType = 'spørsmål'
            this.SideDisplay = this.activeCard.question_text
        },
        saveCompletedQuestions(){
            let arr = JSON.parse(localStorage.getItem('completed_questions_arr')) || []
            let study_course_id = localStorage.getItem('question_set_param').split('-')[0]
            console.log(study_course_id)
            
            const form = new FormData()
            form.append('completed_questions_arr', arr)
            form.append('study_course_id', study_course_id)
        
            axios.post('/api/mark_question_as_completed', form)
            .then(response => {
                console.log(response)
                localStorage.setItem('completed_questions_arr', [])
            })
            .catch(error => {
                console.error(error)
            })
        }
    }
}

</script>
