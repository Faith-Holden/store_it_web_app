class AccessGroup < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}

  has_many :user_accesses
  has_many :users, through: :user_accesses

  has_many :location_accesses
  has_many :locations, through: :location_accesses

  def items
    locations = self.locations
    items = Array.new
    locations.each do |location|
      location.items.each do |item|
        items << item
      end
    end
    items = items.uniq
  end

  def add_location(location)
    self.locations<<location
  end

  # def add_item(item)

  # end

  class <<self
    # returns an array of group ids
    def with_user_visible_locations(user)
      UserAccess.has_user(user)
                .can_see_locations
                .pluck(:access_group_id)
    end

    # returns an array of group ids
    def with_user_visible_items(user)
      UserAccess.has_user(user)
                .can_see_items
                .pluck(:access_group_id)
    end

    # returns an array of group ids
    def with_user_visible_items_and_locations(user)
      UserAccess.has_user(user)
                .can_see_locations
                .can_see_items
                .pluck(:access_group_id)
    end

    def visible_groups(user)
      UserAccess.has_user(user)
                .can_see_group
                .pluck(:access_group_id)
    end

    # returns an array of access_groups from input group ids
    def map_ids_to_groups(ids)
      ids.map{|id| AccessGroup.find_by(id: id)}
    end
    
  end

end
