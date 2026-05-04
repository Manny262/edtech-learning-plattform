<template>
    <main>
        <all_studyplans v-if="!this.$route.params.id" />
        <Studyplan_timeline v-else />
    </main>
</template>

<script>
import all_studyplans from '@/components/all_studyplans.vue';
import Studyplan_timeline from '@/components/studyplan_timeline.vue';

export default {
    components: {
        all_studyplans,
        Studyplan_timeline
    }
}
</script>