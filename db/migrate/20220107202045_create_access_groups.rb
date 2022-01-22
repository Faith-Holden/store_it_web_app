class CreateAccessGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :access_groups do |t|
      t.string :name
      t.text :description
      t.integer :parent_id
      
      t.timestamps
    end
  end
end
