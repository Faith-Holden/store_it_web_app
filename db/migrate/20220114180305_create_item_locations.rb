class CreateItemLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :item_locations do |t|
      t.references :location, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
