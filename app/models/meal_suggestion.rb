class MealSuggestion < ApplicationRecord
  after_create_commit :generate_embedding

  has_neighbors :embedding

  # point to your Ollama server
  ENDPOINT = "http://localhost:11434"

  def get_similar_meal_suggestions
    results = self.nearest_neighbors(:embedding, distance: "cosine").first(5).map{|meal_suggestion| {id: meal_suggestion.id, request_body: meal_suggestion.request_body, distance: meal_suggestion.neighbor_distance}}
    return {
      target: {
        id: self.id,
        request_body: self.request_body
      },
      results: results
    }
  end

  def self.find_by_vector(natural_language_query)
    response = HTTParty.post(
      "#{ENDPOINT}/api/embeddings", 
      body: {
        model: "nomic-embed-text", 
        prompt: natural_language_query,
        stream: false,
      }.to_json,
      debug_output: $stdout,
      timeout: 300,
    ).body
    response_body = JSON.parse(response)
    embedding = response_body["embedding"]
    meal_suggestions = MealSuggestion.nearest_neighbors(:embedding, embedding, distance: "cosine").first(5)
  end

  private

  def process_via_llm
    self.update(status: 'processing')
    messages = []
    user_ingredients = Ingredient.where(spoiled: false).map{|ingredient| ingredient.name}
    messages << {role: 'system', content: "you are a helpful assistant for helping people cook their own meals. The user has the following items in their kitchen: #{user_ingredients.join(', ')}"}
    messages << {role: 'user', content: self.request_body}
    begin
      response = HTTParty.post(
        "#{ENDPOINT}/api/chat", 
        body: {
          model: "mistral", 
          messages: messages,
          stream: false,
        }.to_json,
        debug_output: $stdout,
        timeout: 300,
      ).body
      response_body = JSON.parse(response)
    rescue => e
      self.update(status: "failed generating chat completion - #{e.message}")
    end
    model_response = response_body["message"]["content"]
    self.update(
      response_body: model_response,
      request_metadata: {messages: messages},
      response_metadata: response_body,
      status: 'completed',
    )
  end

  def generate_embedding
    begin
      response = HTTParty.post(
        "#{ENDPOINT}/api/embeddings", 
        body: {
          model: "nomic-embed-text", 
          prompt: self.request_body,
          stream: false,
        }.to_json,
        debug_output: $stdout,
        timeout: 300,
      ).body
      response_body = JSON.parse(response)
      embedding = response_body["embedding"]
      self.update(embedding: embedding)
      self.process_via_llm
    rescue => e
      self.update(status: "failed generating embeddings - #{e.message}")
      throw(:abort)
    end
  end
end
