class AccessGroup < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}

  has_many :subgroups, class_name: "AccessGroup", foreign_key: "parent_id"
  belongs_to :parent, class_name: "AccessGroup", optional: true

  has_many :user_accesses, dependent: :destroy
  has_many :users, through: :user_accesses

  has_many :items_accesses, dependent: :destroy
  has_many :items, through: :items_accesses

  has_many :location_accesses, dependent: :destroy
  has_many :locations, through: :location_accesses

  after_create :create_user_accesses

  def add_location(location)
    unless self.locations.include?(location)
      self.locations<<location 
      location.items.each do |item|
        add_item(item, location)
      end
    end
  end
  
  def remove_location(location)
    location.items.each do |item|
      self.remove_item(item)
    end
    self.location_accesses
        &.find_by(location_id: location.id)
        &.destroy
  end

  def remove_location_tree(location, user)
    location.visible_descendants(user).each do |location|
      self.remove_location(location)
    end
  end

  def add_location_tree(user, location)
    location.visible_descendants(user).each do |location|
      self.add_location(location)
    end
  end


  def add_item(item, location=nil)
    if self.items.include?(item)
      item_access = ItemsAccess.where(access_group_id: self.id)
                                &.find_by(item_id: item.id)
      if location
        item_access.increment_locations
      end
    else
      ItemsAccess.new(item_id: item.id, access_group_id: self.id)
                .save
      if location.nil?
        unless ItemLocation.locationless.where(item_id: item.id).empty? # nil (therefore false), if search result is nil
          ItemLocation.new(item_id: item.id, quantity: 1).save
        end
      else
        ItemLocation.new(location_id: location.id, item_id: item.id, quantity: 1)
                    .save
      end
    end
  end

  def remove_item(item)
    item_access = self.items_accesses.find_by(item_id: item.id)
    return if item_access.nil? 
    item_access.decrement_locations

    # num of locations includes item_locations that have a null location
    #  (items with no physical location -e.g. items in transit)
    if item_access.num_of_locations <= 0
      item_access.destroy
    end
  end

  def remove_user(user)
    UserAccess.has_user(user)
    &.find_by(access_group_id: self.id)
    &.destroy
  end

  def admin_users
    ids = UserAccess.is_group_admin
                     .where(access_group_id: self.id).pluck(:user_id)
    User.where(id: ids)
  end

  def add_user(user)
    self.users << user unless self.users.include?(user)
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

  private
    def create_user_accesses
      parent = self.parent
      unless parent.nil?
        parent.admin_users.each do |user|
          UserAccess.new(user_id: user.id, access_group_id: self.id)
                    .save
          if user.is_sys_admin?
            user.set_user_access_permissions(self, UserAccess::SYS_ADMIN_PERMS)
          else
            user.set_user_access_permissions(self, UserAccess::GROUP_ADMIN_PERMS)
          end
        end
      end


      # It appears that current_user does not exist. variable was set in sessioncontroller, I think
      # @current_user
      # unless self.users.include?(@current_user)
      #   UserAccess.new(user_id: @current_user.id, access_group_id: self.id)
      #             .save
      #   @current_user.set_user_access_permissions(self, UserAccess::GROUP_ADMIN_PERMS)
      # end
    end

end
