<template>
    <div class="login-container">
        <h1>Login</h1>
        <form @submit.prevent="handleLogin">
            <div class="form-group">
                <label for="username">Username:</label>
                <input
                    id="username"
                    v-model="username"
                    type="text"
                    required
                    placeholder="Enter your username"
                />
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input
                    id="password"
                    v-model="password"
                    type="password"
                    required
                    placeholder="Enter your password"
                />
            </div>
            <button type="submit">Login</button>
        </form>
    </div>
</template>

<script>
import axios from 'axios';
import { useAuthStore } from '@/store'

export default {
    data() {
        return {
            username: '',
            password: ''
        }
    },
    methods: {
        async handleLogin() {
           const authStore = useAuthStore();
           await authStore.submitLogin(this.username, this.password)
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
</style>