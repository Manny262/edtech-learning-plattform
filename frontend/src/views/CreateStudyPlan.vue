

<template>
  <main>
    <div id="form-generator">
      <form action="POST" @submit.prevent="MakeStudyPlan()">
        <div>
            <div>
                <label for="subject">Fagområde:</label>
                <input id="subject" v-model="inp.subject" type="text" placeholder="Samfunnskunnskap"required />
            </div>
            <div>
                <label for="level">Nivå:</label>
                <input id="level" v-model="inp.level" type="text" placeholder="Yrkesfag" required />
            </div>
            <div>
                <label for="topic">Tema:</label>
                <input id="topic" v-model="inp.topic" type="text" placeholder="Velferdsstaten" required />
            </div>
            <div>
                <label for="exam_date">Dato for prøve / eksamen:</label>
                <input id="exam_date" v-model="inp.exam_date" type="date" required />
            </div>
            <div>
                <label for="test_type">Tema:</label>
                <input id="test_type" v-model="inp.test_type" type="text" placeholder="fagsamtale"required />
            </div>
            <div>
                <label for="language">Språk:</label>
                <input id="language" v-model="inp.language" type="text" placeholder="Norsk" required />
            </div>
        </div>   
        <div><button type="submit"><span>lag study plan</span></button></div>
      </form>
      <br>
      <div v-if="data"><p>{{ data }}</p></div>
    </div>
  </main>
</template>
<script>
  import axios from 'axios';
  export default {
    data(){
      return {
        data: null,
        inp: {
          subject: '',
          level: '',
          topic: '',
          exam_date: '',
          test_type: '',
          language: ''
        }
      }
    },
    methods: {
      async MakeStudyPlan(){
        const form = new FormData()
        form.append('subject', this.inp.subject)
        form.append('level', this.inp.level)
        form.append('topic', this.inp.topic)
        form.append('exam_date', this.inp.exam_date)
        form.append('test_type', this.inp.test_type)
        form.append('language', this.inp.language)
        try{
          const res = await axios.post('/api/study-plan/generate/', form)
          this.data = res.data
          console.log(this.data)
        }
        catch(error){
          console.error(error)
        }
      }

    }
  }
</script>