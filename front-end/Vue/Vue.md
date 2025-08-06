# Vue 3 Basic Tutorial (Vite + Composition API)

## 1. Create Project

### 1.1 Initialize Vue Project
```bash
npm init vue@latest
```
- Follow the prompts to optionally add TypeScript, Router, Pinia, etc.
- A new Vue 3 + Vite project will be created

### 1.2 Install Dependencies
```bash
cd my-vue-app
npm install
```

### 1.3 Start Development Server
```bash
npm run dev
```

### 1.4 Build for Production
```bash
npm run build
```

---

## 2. Project Structure Overview
```
my-vue-app/
├── public/         # Static assets
├── src/            # Source code
│   ├── assets/     # Static resources
│   ├── components/ # Vue components
│   ├── App.vue     # Root component
│   └── main.js     # Entry file
├── index.html      # HTML template
├── package.json    # Project config and dependencies
└── vite.config.js  # Vite configuration
```

---

## 3. Single File Component (SFC)

### App.vue
```vue
<template>
  <h1>{{ message }}</h1>
</template>

<script setup>
import { ref } from 'vue'

const message = ref('Hello Vue 3')
</script>

<style scoped>
h1 {
  color: #42b983;
}
</style>
```

---

## 4. Component Composition and Usage

### 4.1 Create `HelloWorld.vue`
```vue
<template>
  <p>{{ greeting }}</p>
</template>

<script setup>
const greeting = 'Hello from component'
</script>
```

### 4.2 Import and Use in `App.vue`
```vue
<script setup>
import HelloWorld from './components/HelloWorld.vue'
</script>

<template>
  <h1>My App</h1>
  <HelloWorld />
</template>
```

---

## 5. Event Handling and Data Binding

```vue
<template>
  <button @click="count++">You clicked {{ count }} times</button>
</template>

<script setup>
import { ref } from 'vue'
const count = ref(0)
</script>
```

---

## 6. Conditional and List Rendering

### 6.1 `v-if`
```vue
<template>
  <p v-if="show">Now you see me</p>
</template>

<script setup>
const show = true
</script>
```

### 6.2 `v-for`
```vue
<template>
  <ul>
    <li v-for="(item, index) in items" :key="index">{{ item }}</li>
  </ul>
</template>

<script setup>
const items = ['Apple', 'Banana', 'Cherry']
</script>
```

---

## 7. Forms and Two-Way Binding
```vue
<template>
  <input v-model="name" placeholder="Enter your name" />
  <p>Hello, {{ name }}</p>
</template>

<script setup>
import { ref } from 'vue'
const name = ref('')
</script>
```

---

## 8. Next Steps
- Explore [Vue Router](https://router.vuejs.org/)
- Use [Pinia](https://pinia.vuejs.org/) for global state management
- Add ESLint, Prettier for code quality
- Deploy to GitHub Pages or Vercel

---

## 9. References
- Official Docs: https://vuejs.org
- Vite Docs: https://vitejs.dev
- Recommended Courses: [Vue Mastery](https://www.vuemastery.com/)
