<template>
    <main>
        <h1>Øving</h1>
        <div class="ParentActiveFlashCard">
            <span>{{ this.SideType }}: {{ this.SideDisplay }}</span>
            <button id="showOtherSide" @click="flipCard()"> vis {{ this.otherSide }}</button>
            <div class="ParentNext" v-if="SideType === 'svar'">
                <button @click="nextCard(false)">❌</button>
                <button @click="nextCard(true)">✅</button>
            </div>
        </div>
    </main>
</template>
<script>
import axios from 'axios';
export default {
    // Spørsmål = Question, Svar = Answer 
    
    name: 'practice_page',
    data (){
        return{
            set: [],
            activeCard: {},
            activeCardIndex: 0,
            SideType: 'spørsmål',
            SideDisplay: '',
            otherSide: 'svar',
        } 
    },
    mounted(){
        this.getFlashCards(this.$route.params.set)
    },
    methods: {
        getFlashCards(setParams){
            console.log(setParams)
            console.log(this.$route.params.set)
            axios.get(`/api/get_flashcards/${setParams}/`)
            .then(response =>{
                this.set = response.data 
                console.log(this.set)
                
                localStorage.setItem('question_set_param', setParams)
                localStorage.setItem('questions_arr', JSON.stringify(this.set))
                localStorage.removeItem('completed_questions_arr')

                this.activeCard = this.set[0]
                this.SideDisplay = this.activeCard.question_text    

                console.log('active card:', this.activeCard) 
            })
            .catch(error =>{
                console.error(error)
            })
        },
        flipCard(){
            if(this.SideType === 'spørsmål'){
                this.otherSide = this.SideType
                this.SideType = 'svar'
                this.SideDisplay = this.activeCard.answer_text
            }else{
                this.otherSide = this.SideType
                this.SideType = 'spørsmål'
                this.SideDisplay = this.activeCard.question_text
            }
        },
        nextCard(boolean){
            const current_index = this.activeCardIndex += 1
            let arr = JSON.parse(localStorage.getItem('completed_questions_arr')) || []
            if(boolean){
                arr.push(this.activeCard)
                localStorage.setItem('completed_questions_arr', JSON.stringify(arr))
            }
            
            this.activeCard = this.set[current_index]
            
            this.otherSide = this.SideType
            this.SideType = 'spørsmål'
            this.SideDisplay = this.activeCard.question_text
            
        }
    }
}
</script>