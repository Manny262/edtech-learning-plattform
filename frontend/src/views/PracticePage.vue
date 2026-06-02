<template>
    <main>
        <h1>Øving</h1>
        <FlashCard v-if="task_type === 'Flashcards'" :setParams="$route.params.set" />
        <MultipleChoice v-else-if="task_type === 'Multiple_choices'" :setParams="$route.params.set" />
        <p v-else>Ukjent oppgavetype: {{ task_type }}</p>
    </main>
</template>

<script>
import FlashCard from '@/components/FlashCard.vue';
import MultipleChoice from '@/components/MultipleChoice.vue';

export default {
    name: 'PracticePage',
    components: {
        FlashCard,
        MultipleChoice
    },
    computed: {
        task_type() {
            return this.$route.params.set.split('-').pop()
        }
    }
}
</script>