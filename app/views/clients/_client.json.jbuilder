json.extract! client, :id, :name, :email, :locale, :timezone, :currency, :note, :user_id, :created_at, :updated_at
json.url client_url(client, format: :json)
