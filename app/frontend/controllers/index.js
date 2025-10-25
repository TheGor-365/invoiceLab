// BEGIN app/frontend/controllers/index.js
import { Application } from "@hotwired/stimulus";

export const application = Application.start();

// Экспортируем в window для совместимости со старым кодом (если вдруг)
window.Stimulus = application;

// Авто-регистрация всех контроллеров *_controller.js
const modules = import.meta.glob("./**/*_controller.js", { eager: true });

for (const path in modules) {
  const controller = modules[path].default;
  if (!controller) continue;

  const identifier = path
    .replace("./", "")
    .replace("_controller.js", "")
    .replace(/\//g, "--")
    .replace(/_/g, "-");

  application.register(identifier, controller);
}
// END app/frontend/controllers/index.js
