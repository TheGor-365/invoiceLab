# Create a quick admin for dev
admin = User.where(email: "admin@example.com").first_or_initialize
if admin.new_record?
  admin.password = "password123"
  admin.locale = "en"
  admin.timezone = "Europe/Vienna"
  admin.default_currency = "EUR"
  admin.admin = true
  admin.save!
end
puts "Admin: #{admin.email} / password123"
