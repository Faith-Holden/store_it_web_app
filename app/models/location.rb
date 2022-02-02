class Location < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}

  has_many :child_locations, class_name: "Location", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Location", optional: true

  has_many :item_locations
  has_many :items, through: :item_locations

  has_many :location_accesses
  has_many :access_groups, through: :location_accesses

  
  def add_sublocation(sublocation)
    self.locations<<sublocation
  end

  def add_item(item)
    self.items << item
  end


  def visible_groups(user)
    location_groups = self.access_groups
    visible_groups = user.visible_access_groups
    
    location_groups.each do |location|
      unless visible_groups.include?(location)
        location_groups.delete(location)
      end
    end
    return location_groups
  end

  class << self
    # takes in an array of access_group ids and returns an array of locations
    def locations_in_groups(access_group_ids)
      ids = LocationAccess.where(access_group_id: access_group_ids)
                          .pluck(:location_id)
      
      Location.where(id: ids)
    end

    def visible_to (user)
      access_group_ids = AccessGroup.with_user_visible_locations(user)
      Location.locations_in_groups(access_group_ids)
    end



  end

end
