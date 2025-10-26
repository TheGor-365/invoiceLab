// app/frontend/controllers/line_items_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "container",
    "template",
    "currencySelect",
    "currencyBadge",
    "subtotalAmount",
    "subtotalCurrency"
  ];

  connect() {
    this.syncCurrencyBadges();
    this.recalc();
  }

  add(event) {
    event.preventDefault();
    const html = this.templateTarget.innerHTML.replaceAll("NEW_RECORD", Date.now().toString());
    const wrapper = document.createElement("tbody");
    wrapper.innerHTML = html.trim();
    const row = wrapper.firstElementChild;
    this.containerTarget.appendChild(row);
    this.syncCurrencyBadges();
    this.recalc();
  }

  remove(event) {
    event.preventDefault();
    const row = event.target.closest("[data-line-item-row]");
    if (!row) return;

    const destroyInput = row.querySelector('input[name$="[_destroy]"]');
    if (destroyInput) {
      destroyInput.value = "1";
      row.style.display = "none";
    } else {
      row.remove();
    }
    this.recalc();
  }

  currencyChanged() {
    this.syncCurrencyBadges();
    if (this.hasSubtotalCurrencyTarget) {
      this.subtotalCurrencyTarget.textContent = this.currentCurrency();
    }
  }

  recalc() {
    let totalCents = 0;

    this.rows().forEach(row => {
      const destroy = row.querySelector('input[name$="[_destroy]"]');
      if (destroy && destroy.value === "1") return;

      const qStr = row.querySelector('input[name$="[quantity]"]')?.value ?? "0";
      const pStr = row.querySelector('input[name$="[unit_price_cents]"]')?.value ?? "0";
      const q = parseFloat(qStr);
      const priceCents = parseInt(pStr, 10);

      if (!Number.isNaN(q) && !Number.isNaN(priceCents)) {
        totalCents += Math.round(q * priceCents);
      }
    });

    if (this.hasSubtotalAmountTarget) {
      this.subtotalAmountTarget.textContent = this.formatAmount(totalCents);
    }
    if (this.hasSubtotalCurrencyTarget) {
      this.subtotalCurrencyTarget.textContent = this.currentCurrency();
    }
  }

  // Helpers
  rows() {
    return Array.from(this.containerTarget.querySelectorAll("[data-line-item-row]"));
  }

  currentCurrency() {
    return this.hasCurrencySelectTarget ? this.currencySelectTarget.value : "USD";
  }

  syncCurrencyBadges() {
    const cur = this.currentCurrency();
    this.currencyBadgeTargets.forEach(el => (el.textContent = cur));
  }

  formatAmount(cents) {
    return (cents / 100).toFixed(2);
  }
}
