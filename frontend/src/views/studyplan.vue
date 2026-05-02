<template>
    <main>
        <all_studyplans v-if="!$route.query || Object.keys($route.query).length === 0" />
        <h1 v-else>timeline</h1>
    </main>
</template>

<script>
import all_studyplans from '@/components/all_studyplans.vue';

export default {
    components: {
        all_studyplans
    }
}
</script>