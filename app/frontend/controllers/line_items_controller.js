// BEGIN app/frontend/controllers/line_items_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "template"];

  connect() {
    // console.debug("[line-items] connected");
  }

  add(event) {
    event.preventDefault();
    const html = this.templateTarget.innerHTML.replaceAll("NEW_RECORD", Date.now().toString());
    this.containerTarget.insertAdjacentHTML("beforeend", html);
  }

  remove(event) {
    event.preventDefault();
    const row = event.target.closest("[data-line-item-row]");
    if (!row) return;

    const destroyInput = row.querySelector('input[name$="[_destroy]"]');
    const idInput = row.querySelector('input[name$="[id]"]');

    // Если запись новая — просто удаляем из DOM
    if (!idInput || idInput.value === "" || idInput.value === "0") {
      row.remove();
      return;
    }

    // Иначе помечаем на удаление и прячем
    if (destroyInput) destroyInput.value = "1";
    row.style.display = "none";
  }
}
// END app/frontend/controllers/line_items_controller.js
