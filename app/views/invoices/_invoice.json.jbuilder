json.extract! invoice, :id, :number, :status, :currency, :total_cents, :due_date, :issued_on, :paid_at, :stripe_checkout_session_id, :payment_url, :notes, :user_id, :client_id, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
