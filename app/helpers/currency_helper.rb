module CurrencyHelper
  # Принимает amount в центах и строку кода валюты (e.g. "USD")
  def cents_to_money(amount_cents, currency)
    return "" if amount_cents.nil?
    number_to_currency(amount_cents.to_f / 100.0, unit: currency, format: "%u %n", precision: 2)
  end
end
