class AddEmbeddingToMealSuggestions < ActiveRecord::Migration[7.1]
  def change
    # limit: derived from nomic docs: https://blog.nomic.ai/posts/nomic-embed-mongo
    add_column :meal_suggestions, :embedding, :vector, limit: 768 
  end
end
