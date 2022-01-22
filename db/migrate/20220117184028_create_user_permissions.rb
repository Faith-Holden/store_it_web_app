class CreateUserPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_permissions do |t|
      t.references :user
      t.boolean :is_sys_admin
      t.boolean :can_crud_items
      t.boolean :can_crud_access_group_no_parent
      t.boolean :can_crud_locations_with_parent
      t.boolean :can_crud_locations_no_parent
      t.timestamps
    end
  end
end
