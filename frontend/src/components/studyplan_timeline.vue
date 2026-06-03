<template>
  <div class="timeline-container">
    <div v-for="day in studyDays" :key="day.study_day_id">
      <div>
        <h3>{{ formatDate(day.scheduled_date) }}</h3>
        <p>Fokusområde: {{ day.focus_area }}</p>
      </div>
      
      <div>
        <h4>Oppgaver:</h4>
        <div>
          <div v-for="task in day.tasks" :key="task.task_id">
            <button v-if="task.set_number" 
            @click="$router.push(`/practice-page/${routeStudyCourseID}-${task.set_number}-${task.type_name}`)" 
            style="cursor: pointer;">
            {{ task.description }}
          </button>
            <span v-else>{{ task.description }}</span>
            <span v-if="task.task_type_id">({{ task.task_type_id }})</span>
          </div>
          </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'StudyplanTimeline',
  data() {
    return {
      studyDays: [],
      routeStudyCourseID: this.$route.params.id
    }
  },
  mounted(){
    this.fetch_study_plan()
  },
  methods: {
    fetch_study_plan() {
        console.log(this.$route.params.id)
        axios.get(`/api/study-plan/${this.$route.params.id}/`)
        .then(response => {
            this.studyDays = response.data
            console.log(response.data)
        })
        .catch(error => {
            console.error('Error fetching Study Timeline', error)
        })
    },

    formatDate(dateString) {
      const options = { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
      };
      return new Date(dateString).toLocaleDateString('no-NO', options);
    }
  }
};
</script>

<style scoped>
.timeline-container {
  max-height: 80vh;
  overflow-y: auto;
  padding: 16px;
}
</style>
