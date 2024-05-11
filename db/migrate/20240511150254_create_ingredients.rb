class CreateIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :quantity
      t.bigint :price_cents
      t.boolean :spoiled
      t.datetime :expiry_date

      t.timestamps
    end
  end
end
