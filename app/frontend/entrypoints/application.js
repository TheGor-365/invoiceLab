// Bootstrap JS
import "bootstrap/dist/js/bootstrap.bundle"

// Styles
import "../styles/application.scss"

// Hotwire (Turbo) JS part (server helpers via gem turbo-rails)
import "@hotwired/turbo-rails"

// Stimulus setup
import { Application } from "@hotwired/stimulus"
import HelloController from "../controllers/hello_controller.js"

window.Stimulus = Application.start()
Stimulus.register("hello", HelloController)

// Vue mount (sample widget)
import { createApp } from "vue"
import HelloVue from "../vue/HelloVue.vue"

document.addEventListener("DOMContentLoaded", () => {
  const el = document.getElementById("hello-vue")
  if (el) createApp(HelloVue, { msg: "Vue + Vite + Turbo ✅" }).mount(el)
})
