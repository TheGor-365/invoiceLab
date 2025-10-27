# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_10_26_193603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "locale", default: "en", null: false
    t.string "timezone", default: "UTC", null: false
    t.string "currency", default: "USD", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency"], name: "index_clients_on_currency"
    t.index ["locale"], name: "index_clients_on_locale"
    t.index ["timezone"], name: "index_clients_on_timezone"
    t.index ["user_id", "email"], name: "index_clients_on_user_id_and_email"
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "email_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "invoice_id", null: false
    t.string "kind", null: false
    t.string "to", null: false
    t.string "subject", null: false
    t.integer "status", default: 0, null: false
    t.string "message_id"
    t.text "error"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id", "kind", "created_at"], name: "index_email_logs_on_invoice_id_and_kind_and_created_at"
    t.index ["invoice_id"], name: "index_email_logs_on_invoice_id"
    t.index ["user_id"], name: "index_email_logs_on_user_id"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.string "name", null: false
    t.text "description"
    t.decimal "quantity", precision: 10, scale: 2, default: "1.0", null: false
    t.integer "unit_price_cents", default: 0, null: false
    t.integer "total_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "client_id", null: false
    t.string "number", null: false
    t.integer "status", default: 0, null: false
    t.string "currency", default: "USD", null: false
    t.integer "total_cents", default: 0, null: false
    t.date "issued_on"
    t.date "due_date", null: false
    t.datetime "paid_at"
    t.string "stripe_checkout_session_id"
    t.string "payment_url"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["due_date"], name: "index_invoices_on_due_date"
    t.index ["status"], name: "index_invoices_on_status"
    t.index ["user_id", "number"], name: "index_invoices_on_user_id_and_number", unique: true
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale", default: "en", null: false
    t.string "timezone", default: "UTC", null: false
    t.string "default_currency", limit: 3, default: "USD", null: false
    t.boolean "admin", default: false, null: false
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.string "plan"
    t.string "subscription_status"
    t.datetime "trial_ends_at"
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id"
    t.index ["stripe_subscription_id"], name: "index_users_on_stripe_subscription_id"
    t.check_constraint "char_length(default_currency::text) = 3", name: "users_default_currency_len"
  end

  add_foreign_key "clients", "users"
  add_foreign_key "email_logs", "invoices"
  add_foreign_key "email_logs", "users"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "users"
end
