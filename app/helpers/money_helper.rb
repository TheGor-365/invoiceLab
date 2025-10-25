module MoneyHelper
  # Very basic money formatting from cents
  def money_cents(cents, currency = "USD")
    amount = (cents.to_i / 100.0)
    number_to_currency(amount, unit: currency_symbol(currency), precision: 2, format: "%u %n")
  end

  def currency_symbol(iso)
    case iso.to_s.upcase
    when "USD" then "$"
    when "EUR" then "€"
    when "RUB", "RUR" then "₽"
    else iso.to_s.upcase
    end
  end
end
