json.extract! ingredient, :id, :name, :quantity, :price_cents, :spoiled, :expiry_date, :created_at, :updated_at
json.url ingredient_url(ingredient, format: :json)
