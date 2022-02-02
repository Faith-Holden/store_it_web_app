class AccessGroup < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}

  has_many :user_accesses
  has_many :users, through: :user_accesses

  has_many :items_accesses
  has_many :items, through: :items_accesses

  has_many :location_accesses
  has_many :locations, through: :location_accesses

  def group_items
    locations = self.locations
    items = self.items
    locations.each do |location|
      location.items.each do |item|
        items << item
      end
    end
    items = items.uniq.sort_by{ |item| item.id }
  end

  def add_location(location)
    self.locations<<location
  end

  def add_item(item)
    self.items << item
  end

  def add_user(user)
    self.users << user
  end

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
