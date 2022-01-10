class Locations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.text :description
      t.integer :parent
      t.references :access_group, null: false, foreign_key: true
    
      t.timestamps
    end
  end
end
