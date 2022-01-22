class CreateUserAccesses < ActiveRecord::Migration[6.1]
  def change
    create_table :user_accesses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :access_group, null: false, foreign_key: true
      t.boolean :group_admin
      t.boolean :can_see_group
      t.boolean :can_see_items
      t.boolean :can_see_locations
      t.boolean :can_crud_group
      t.boolean :can_crud_user_access
      t.boolean :can_crud_subgroups
      t.boolean :can_crud_item_access
      t.boolean :can_crud_location_access
      t.timestamps
    end
  end
end
