// BEGIN app/frontend/entrypoints/application.js
// Turbo
import "@hotwired/turbo-rails";

// Stimulus (auto-registers everything in ../controllers)
import "../controllers";

// Bootstrap JS (collapse, dropdowns, etc.)
import * as bootstrap from "bootstrap";

// SCSS: подключаем ядро стилей из JS, чтобы избежать 404 на CSS-entrypoint в dev
import "../styles/application.scss";
// END app/frontend/entrypoints/application.js
