<template>
    <div class="login-container">
        <h1>Logg inn</h1>
        <form @submit.prevent="handleLogin">
            <div class="form-group">
                <label for="username">Brukernavn:</label>
                <input
                    id="username"
                    v-model="username"
                    type="text"
                    required
                    placeholder="Skriv inn brukernavn"
                />
            </div>
            <div class="form-group">
                <label for="password">Passord:</label>
                <input
                    id="current-password"
                    data-v-d0e06bca
                    v-model="password"
                    type="password"
                    required
                    placeholder="Skriv inn passord"
                />
            </div>
            <button type="submit">Logg inn</button>
        </form>
<!-- 
        <div class="separator">eller</div>

        <form @submit.prevent="handleGoogleLogin">
            <div class="form-group">
                <label for="google-token">Google access token:</label>
                <input
                    id="google-token"
                    v-model="googleAccessToken"
                    type="text"
                    required
                    placeholder="Lim inn Google access token"
                />
            </div>
            <button type="submit" class="google-button">Logg inn med Google</button>
        </form> -->

        <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
        <p class="signup-text">
            Har du ikke bruker?
            <router-link to="/signup">Opprett konto</router-link>
        </p>
    </div>
</template>

<script>
import { useAuthStore } from '@/store'

export default {
    data() {
        return {
            username: '',
            password: '',
            googleAccessToken: '',
            errorMessage: ''
        }
    },
    methods: {
        async handleLogin() {
           this.errorMessage = '';
           const authStore = useAuthStore();
           await authStore.submitLogin(this.username, this.password)
        },
        handleGoogleLogin() {
            this.errorMessage = '';
            const authStore = useAuthStore();
            authStore
                .submitGoogleLogin(this.googleAccessToken)
                .catch((error) => {
                    console.error('Google login feilet:', error);
                    this.errorMessage = 'Google-innlogging feilet. Sjekk token og prov igjen.';
                });
        }
    }
}
</script>

<style scoped>
.login-container {
    max-width: 400px;
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

.separator {
    margin: 16px 0;
    text-align: center;
    color: #666;
}

.google-button {
    margin-top: 4px;
    background-color: #d93025;
}

.google-button:hover {
    background-color: #b3261e;
}

.error-message {
    margin-top: 12px;
    color: #b00020;
    font-size: 14px;
}

.signup-text {
    margin-top: 16px;
    text-align: center;
}
</style>