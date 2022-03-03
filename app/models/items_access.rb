class ItemsAccess < ApplicationRecord
  belongs_to :access_group
  belongs_to :item

  def increment_locations
    self.update_attribute(:num_of_locations, self.num_of_locations+1)
  end

  def decrement_locations
    self.update_attribute(:num_of_locations, self.num_of_locations-1)
  end
end
