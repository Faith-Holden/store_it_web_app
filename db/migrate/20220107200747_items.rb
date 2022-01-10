class Items < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.references :access_group, null: false, foreign_key: true
      t.references :location, foreign_key: true
    
      t.timestamps
    end
  end
end
