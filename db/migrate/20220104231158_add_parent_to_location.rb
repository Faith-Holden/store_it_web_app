class AddParentToLocation < ActiveRecord::Migration[6.1]
  def change
    add_reference :locations, :location, null: false, foreign_key: true
  end

  add_index :locations, :parent_id
  add_index :locations, :child_id
  add_index :locations, [:parent_id, :child_id], unique: true

end
