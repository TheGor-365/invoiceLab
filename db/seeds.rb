# Create admin for dev/demo
admin = User.where(email: "admin@example.com").first_or_initialize
if admin.new_record?
  admin.password = "password123"
  admin.locale = "en"
  admin.timezone = "Europe/Vienna"
  admin.default_currency = "EUR"
  admin.admin = true
  admin.save!
end
puts "Seeded admin: #{admin.email}"

# Demo clients (ASCII emails to satisfy URI::MailTo::EMAIL_REGEXP)
c1 = admin.clients.find_or_create_by!(email: "client1@example.com") do |c|
  c.name = "Acme LLC"
  c.locale = "en"
  c.timezone = "America/New_York"
  c.currency = "USD"
  c.note = "Main US client"
end

c2 = admin.clients.find_or_create_by!(email: "cliente2@example.com") do |c|
  c.name = "Clientes Iberia"
  c.locale = "es"
  c.timezone = "Europe/Madrid"
  c.currency = "EUR"
  c.note = "Spain-based"
end

c3 = admin.clients.find_or_create_by!(email: "client3@example.ru") do |c|
  c.name = "ООО Ромашка"
  c.locale = "ru"
  c.timezone = "Europe/Moscow"
  c.currency = "RUB"
  c.note = "Russian-speaking"
end

# Demo invoice with items for c1
inv = admin.invoices.where(client: c1).first_or_initialize(due_date: Date.current + 7.days)
if inv.new_record?
  inv.currency = c1.currency
  inv.notes = "Website development sprint 1"
  inv.invoice_items.build(name: "Development hours", quantity: 10, unit_price_cents: 8000) # $80/hour
  inv.invoice_items.build(name: "Design revision", quantity: 3, unit_price_cents: 6000)  # $60/hour
  inv.save!
end

puts "Clients: #{[c1.email, c2.email, c3.email].join(', ')}"
puts "Invoice: #{inv.number} -> total #{inv.total_cents} #{inv.currency}"
