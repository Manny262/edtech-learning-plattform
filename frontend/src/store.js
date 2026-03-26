import { defineStore } from "pinia";
import axios from "axios";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    user: null,
    isAuthenticated: false,
  }),
  actions: {
    async submitLogin(username, password) {
        axios.post('/api/auth/login/',  {username: username, password: password})
                .then(response => {
                    this.user = response.data;
                    this.isAuthenticated = true;
                    
                    console.log('Login successful:', response.data);
                    window.location.href = '/about'
                })
                .catch(error => {
                    console.error('Login failed:', error);
                    // Handle login error
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