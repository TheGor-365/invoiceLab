<template>
  <div class="card shadow-sm">
    <div class="card-body">
      <h5 class="card-title">Hello from Vue</h5>
      <p class="card-text">{{ msg }}</p>
      <button class="btn btn-outline-primary btn-sm" @click="count++">
        Clicked {{ count }} times
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue"
defineProps({ msg: { type: String, default: "" } })
const count = ref(0)
</script>

<style scoped>
.card { border-radius: 12px; }
</style>
