class CreateBusinessIntelligenceRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :business_intelligence_requests do |t|
      t.string :status
      t.jsonb :request_metadata
      t.jsonb :response_metadata
      t.text :request_body
      t.text :response_body

      t.timestamps
    end
  end
end
