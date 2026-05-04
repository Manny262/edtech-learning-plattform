<template>
  <div class="study-plans-container">
    <h1>Studieplaner</h1>
    <div class="study-plans-list">
      <div v-if="studyPlans.length === 0" class="no-plans">
        <p>Ingen studieplaner tilgjengelig</p>
      </div>
      <div v-else>
        <div v-for="plan in studyPlans" :key="plan.study_course_id" class="study-plan-card">
          <div class="plan-header">
            <h2>{{ plan.topic }}</h2>
            <span class="exam-date">{{ plan.exam_date }}</span>
          </div>
          <div class="plan-body">
            <p><strong>Fag:</strong> {{ plan.subject }}</p>
            <p><strong>Emne:</strong> {{ plan.topic }}</p>
            <p><strong>Testtype:</strong> {{ plan.test_type }}</p>            
            <p><strong>Opprettet:</strong> {{ plan.created_at }}</p>
          </div>
          <div class="plan-actions">
            <button class="btn-view" @click="$router.push(`/timeline/${plan.study_course_id}`)">Vis</button>
            <button class="btn-edit">Rediger</button>
            <button class="btn-delete">Slett</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'AllStudyPlans',
  data() {
    return {
      studyPlans: ''
    }
  },
  
  mounted() {
    this.fetchStudyPlans();
  },
  
  methods: {
    fetchStudyPlans() {
      axios.get('/api/study-plan/')
      .then(response => {
        this.studyPlans = response.data
        console.log(response.data)
      })
      .catch(error => {
        console.error('Error fetching study plans:', error);
      });
    },
  }
}
</script>

<style scoped>
.study-plans-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.study-plans-container h1 {
  color: #333;
  margin-bottom: 30px;
  font-size: 2rem;
  text-align: center;
}

.study-plans-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 20px;
}

.no-plans {
  grid-column: 1 / -1;
  text-align: center;
  color: #999;
  padding: 40px;
  font-size: 1.1rem;
}

</style>
