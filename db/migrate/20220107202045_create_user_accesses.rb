class CreateUserAccesses < ActiveRecord::Migration[6.1]
  def change
    create_table :user_accesses do |t|
      t.integer :access_level
      t.references :user, null: false, foreign_key: true
      t.references :access_group, null: false, foreign_key: true
    
      t.timestamps
    end
  end
end
