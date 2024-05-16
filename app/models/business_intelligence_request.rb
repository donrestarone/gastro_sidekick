class BusinessIntelligenceRequest < ApplicationRecord
  after_create_commit :process_via_llm
  # point to your Ollama server
  ENDPOINT = "http://localhost:11434"

  private

  def process_via_llm
    self.update(status: 'processing')
    messages = []
    ingredients = Ingredient.all.map{|ingredient| ingredient.name}
    meal_suggestions = MealSuggestion.find_by_vector(self.request_body)
    meal_suggestion_embeddings = meal_suggestions.map{|meal_suggestion| meal_suggestion.embedding}
    messages << {role: 'system', content: "you are a business intelligence and marketing wizard at a SaaS company that helps users manage their kitchen supplies and meal creation. Here's what our users are buying: #{ingredients.join(', ')}. Here's what our users are saying: #{meal_suggestion_embeddings}"}
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
      self.update(status: "failed - #{e.message}")
    end
    model_response = response_body["message"]["content"]
    self.update(
      response_body: model_response,
      request_metadata: {messages: messages},
      response_metadata: response_body,
      status: 'completed',
    )
  end
end
