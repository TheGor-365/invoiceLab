// Safe demo controller; doesn't rely on window.Stimulus
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // console.debug("hello_controller connected");
  }
}
