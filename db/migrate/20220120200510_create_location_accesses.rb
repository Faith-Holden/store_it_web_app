class CreateLocationAccesses < ActiveRecord::Migration[6.1]
  def change
    create_table :location_accesses do |t|
      t.references :location
      t.references :access_group

      t.timestamps
    end
  end
end
