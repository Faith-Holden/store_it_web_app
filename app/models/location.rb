class Location < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                                    size: { less_than: 5.megabytes,
                                     message: "should be less than 5MB" }

  has_many :sublocations, class_name: "Location", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Location", optional: true

  has_many :item_locations, dependent: :destroy
  has_many :items, through: :item_locations

  has_many :location_accesses, dependent: :destroy
  has_many :access_groups, through: :location_accesses

  has_one_attached :image

  def add_sublocation(sublocation)
    self.sublocations<<sublocation
  end
  
  def destroy_location
    self.sublocations.each do |sublocation|
      sublocation.update_attribute(:parent_id, nil)
    end
    self.destroy
  end

  def add_item(item, quantity=1)
    if self.items.include?(item)
      ItemLocation.where(location_id: self.id)
      &.find_by(item_id: item.id)
      &.increment_quantity(quantity)
    else
      self.items << item
    end
  end

  def visible_sublocations(user)
    if user.is_sys_admin?
      return self.sublocations
    end
    visible_sublocations = Array.new
    self.sublocations.each do |sublocation|
      visible_sublocations << sublocation if sublocation.is_visible?(user)
    end
    return visible_sublocations
    
    
    # access_group_ids = UserAccess.has_user(user)
    #                               &.can_crud_location_access
    #                               &.pluck(:access_group_id)
    # location_ids = LocationAccess.where(access_group_id: access_group_ids)
    #                           &.pluck(:location_id)
    # self.sublocations&.where(id: location_ids)
  end

  def visible_descendants(user)
    descendants = self.descendants
    if user.is_sys_admin?
      return descendants
    end
    visible_descendants = Array.new
    descendants.each do |descendant|
      if descendant.is_visible?(user)
        visible_descendants << descendant
      end
    end
    return visible_descendants
  end

  def descendants
      descendants = Array.new
      children = self.sublocations
      # base case
      if children.empty?
        loc_array = Array.new
        loc_array << self
        return loc_array
      # otherwise
      else
        children.each do |child|
          result = child.descendants
          descendants << result
          descendants.flatten!
        end
        descendants << self
        return descendants
      end
  end



  def root_visible_ancestor?(user)
    # debugger
    if self.parent_id.nil?
      return true
    end
    return !self.parent.is_visible?(user)
  end

  # def get_root_visible_location(user)
  #   unless self.parent_id == nil
  #     parent = Location.find_by(id: self.parent_id)
  #     if parent.is_visible?(user)
  #       parent.get_root_visible_location(user)
  #     end
  #   end
  #   return self
  # end
  
  def is_visible?(user)
    if user.is_sys_admin?
      return true
    end
    access_group_ids = LocationAccess.where(location_id: self.id).pluck(:access_group_id)
    return (UserAccess.has_user(user)
              &.where(access_group_id: access_group_ids)
              &.where(can_see_locations: true)
              .count) > 0
    # access_group_ids = AccessGroup.with_user_visible_locations(user)
    # Location.locations_in_groups(access_group_ids)
    #         .include?(self)
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
  end

end
