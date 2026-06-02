import { defineStore } from "pinia";
import axios from "axios";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    user: null,
    isAuthenticated: false,
    token: null,
  }),
  actions: {
    async setAuthState(data) {
      this.user = data;
      this.isAuthenticated = true;
      this.token = data?.token || null;

      if (this.token) {
        localStorage.setItem("jwt_token", this.token);
        axios.defaults.headers.common.Authorization = `Bearer ${this.token}`;
      }
    },
    async submitLogin(username, password) {
      try {
        const response = await axios.post('/api/auth/login/', {username: username, password: password});
        this.setAuthState(response.data);
        
        console.log('Login successful:', response.data);
        window.location.href = '/timeline';
      } catch (error) {
        console.error('Login failed:', error);
        this.isAuthenticated = false;
      }
    },
    // async submitGoogleLogin(accessToken) {
    //   return axios
    //     .post('/api/auth/social/google/', {
    //       access_token: accessToken,
    //     })
    //     .then((response) => {
    //       this.setAuthState(response.data);
    //       window.location.href = '/about'
    //     })
    //     .catch((error) => {
    //       this.isAuthenticated = false;
    //       throw error;
    //     });
    // },
    async submitRegistration(payload) {
      return axios
        .post('/api/auth/registration/', payload)
        .then((response) => response.data)
        .catch((error) => {
          throw error;
        });
    },
    async checkAuth() {
      console.log("checking status");
      try{
      
      const res = await axios.get("/api/auth/user/", {
        withCredentials: true,
      });
      if (res.status === 200) {
        this.user = res.data;

        this.isAuthenticated = true;
        console.log("✅ authenticated: ", this.user);}
      }catch(err){
          console.log("❌ Not authenticated!");
          this.isAuthenticated = false;
        
      }

      }
    ,
    async logout() {
      await axios
        .get("/api/auth/logout/", { withCredentials: true })
        .then(() => {
          this.user = null;
          this.isAuthenticated = false;
          console.log("logged Out!");
          window.location.href='/'
        })
        .catch((err) => {
          console.error(err);
        });
    },
  },
});