class CreateItemsAccesses < ActiveRecord::Migration[6.1]
  def change
    create_table :items_accesses do |t|
      t.references :access_group, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :num_of_locations, null: false, default: 0

      t.timestamps
    end
  end
end
