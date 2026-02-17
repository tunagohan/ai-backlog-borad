export default defineNuxtConfig({
  srcDir: '.',
  css: ['~/assets/css/main.css'],
  runtimeConfig: {
    public: {
      apiBaseUrl: process.env.NUXT_PUBLIC_API_BASE_URL || 'http://localhost:3000/api/v1'
    }
  },
  modules: ['@nuxt/ui']
})
