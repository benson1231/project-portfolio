<script setup>
import HelloWorld from './components/HelloWorld.vue'
import TheWelcome from './components/TheWelcome.vue'
console.log("Hello world");
let message = "Hello vue";
let word = "<u>important</u>";
let name = "content";
let checked = false;
</script>

<template>
  <header>
    <img alt="Vue logo" class="logo" src="./assets/logo.svg" width="125" height="125" />

    <div class="wrapper">
      <HelloWorld msg="You did it!" />
    </div>
  </header>

  <main>
    <button class="btn btn-success">Click me</button>
    <p>{{ message }}</p>
    <p>{{ message.toUpperCase() }}</p>
    <p v-html="word"></p>
    <div :class="name">apple</div>
    <p :class="checked?'':'active'">apple</p>
    <TheWelcome />
  </main>
</template>

<style scoped>
header {
  line-height: 1.5;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  .content {
    color: red;
  }

  .active {
    color: green;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style>
