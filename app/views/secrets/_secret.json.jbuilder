json.extract! secret, :id, :name, :value, :domain, :created_at, :updated_at
json.url secret_url(secret, format: :json)
