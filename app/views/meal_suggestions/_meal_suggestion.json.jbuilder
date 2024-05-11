json.extract! meal_suggestion, :id, :status, :request_metadata, :response_metadata, :request_body, :response_body, :created_at, :updated_at
json.url meal_suggestion_url(meal_suggestion, format: :json)
