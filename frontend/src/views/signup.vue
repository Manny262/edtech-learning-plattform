<template>
    <div class="signup-container">
        <h1>Opprett konto</h1>

        <form @submit.prevent="handleSignup">
            <div class="form-group">
                <label for="username">Brukernavn:</label>
                <input
                    id="username"
                    v-model="username"
                    type="text"
                    required
                    placeholder="Velg et brukernavn"
                />
            </div>

            <div class="form-group">
                <label for="email">E-post:</label>
                <input
                    id="email"
                    v-model="email"
                    type="email"
                    placeholder="Skriv inn e-post"
                />
            </div>

            <div class="form-group">
                <label for="password1">Passord:</label>
                <input
                    id="password1"
                    v-model="password1"
                    type="password"
                    required
                    placeholder="Skriv inn passord"
                />
            </div>

            <div class="form-group">
                <label for="password2">Bekreft passord:</label>
                <input
                    id="password2"
                    v-model="password2"
                    type="password"
                    required
                    placeholder="Skriv inn passord igjen"
                />
            </div>

            <button type="submit">Opprett konto</button>
        </form>

        <p v-if="successMessage" class="success-message">{{ successMessage }}</p>
        <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>

        <p class="login-text">
            Har du allerede bruker?
            <router-link to="/login">Logg inn</router-link>
        </p>
    </div>
</template>

<script>
import { useAuthStore } from '@/store'

export default {
    data() {
        return {
            username: '',
            email: '',
            password1: '',
            password2: '',
            successMessage: '',
            errorMessage: ''
        }
    },
    methods: {
        handleSignup() {
            this.successMessage = '';
            this.errorMessage = '';
            const authStore = useAuthStore();

            authStore
                .submitRegistration({
                    username: this.username,
                    email: this.email,
                    password1: this.password1,
                    password2: this.password2
                })
                .then(() => {
                    this.successMessage = 'Konto opprettet! Du kan logge inn nå.';
                    this.username = '';
                    this.email = '';
                    this.password1 = '';
                    this.password2 = '';
                    setTimeout(() => {
                        this.$router.push('/login');
                    }, 800);
                })
                .catch((error) => {
                    console.error('Registrering feilet:', error);
                    if (error.response?.data) {
                        const firstError = Object.values(error.response.data)[0];
                        this.errorMessage = Array.isArray(firstError)
                            ? firstError[0]
                            : 'Registrering feilet. Prøv igjen.';
                    } else {
                        this.errorMessage = 'Kunne ikke kontakte serveren. Prøv igjen.';
                    }
                });
        }
    }
}
</script>

<style scoped>
.signup-container {
    max-width: 420px;
    margin: 50px auto;
    padding: 20px;
    border: 1px solid #ddd;
    border-radius: 8px;
}

.form-group {
    margin-bottom: 15px;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}

input {
    width: 100%;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
}

button {
    width: 100%;
    padding: 10px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
}

button:hover {
    background-color: #0056b3;
}

.success-message {
    margin-top: 12px;
    color: #1b5e20;
    font-size: 14px;
}

.error-message {
    margin-top: 12px;
    color: #b00020;
    font-size: 14px;
}

.login-text {
    margin-top: 16px;
    text-align: center;
}
</style>
