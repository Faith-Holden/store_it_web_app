class User < ApplicationRecord
  attr_accessor :activation_token

  has_one :user_permission, dependent: :destroy
  has_many :user_accesses, dependent: :destroy
  has_many :access_groups, through: :user_accesses

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                   length: {maximum: 100},
                   format: {with: VALID_EMAIL_REGEX},
                   uniqueness: true
  validates :password, presence: true, length: { minimum: 6}, allow_nil: true

  before_save :downcase_email
  before_create :create_activation_digest
  after_create :create_user_perms

  has_secure_password

  # -------------------------Getters ----------------------------
  # returns an array of items that a user can see
  def items
    if self.is_sys_admin?
      return Item.all
    end
    all_items = Array.new
    self.locations_with_visible_items.each do |location|
      location.items.each do |item|
        all_items << item
      end
    end
    all_items = all_items.uniq
  end

  def crudable_access_location_tree(location)
    crudable_descendants = Array.new
    children = location.visible_sublocations(self)
    # base case
    if children.empty?
      return location
    # otherwise
    else
      children.each do |child|
        result = crudable_access_location_tree(child)
        crudable_descendants << result
        crudable_descendants.flatten!
      end
      crudable_descendants << location
      return crudable_descendants
    end
  end

  def visible_ancestor_locations
    locations = Array.new
    self.locations.each do |location|
      if location.root_visible_ancestor?(self)
        locations << location
      end
    end
    return locations
  end

  def visible_access_groups
    ids = AccessGroup.visible_groups(self)
    AccessGroup.map_ids_to_groups(ids)
  end

  # returns an array of locations where user can see items
  def locations_with_visible_items
    access_group_ids = AccessGroup.with_user_visible_items_and_locations(self)
    Location.locations_in_groups(access_group_ids)
  end

  # returns an array of locations that a user can see
  def locations
    if self.is_sys_admin?
      Location.all
    else
      access_group_ids = AccessGroup.with_user_visible_locations(self)
      Location.locations_in_groups(access_group_ids)
    end
  end

  def groups_user_can_crud_subgroup
    user_accesses = UserAccess.has_user(self).can_crud_subgroup
    AccessGroup.where(id: user_accesses)
  end

  def groups_user_can_crud_location_access
    user_accesses = UserAccess.has_user(self).can_crud_location_access
    AccessGroup.where(id: user_accesses)
  end

  def groups_user_can_crud_item_access
    user_accesses = UserAccess.has_user(self).can_crud_item_access
    AccessGroup.where(id: user_accesses)
  end

  
  # -------------------------------------------------------------

  #------------------------boolean queries ----------------------

  def can_crud_items?
    UserPermission.find_by(user_id: self.id).can_crud_locations_no_parent
  end

  def can_crud_root_location?
    UserPermission.find_by(user_id: self.id).can_crud_locations_no_parent
  end

  def can_crud_non_root_location?
    UserPermission.find_by(user_id: self.id).can_crud_locations_with_parent
  end


  def can_crud_root_group?
    UserPermission.find_by(user_id: self.id).can_crud_access_group_no_parent
  end

  def can_crud_group?(access_group)
    user_access = UserAccess.group_with_user(access_group, self)
    return false if user_access.nil?
    return user_access.can_crud_group
  end

  def can_crud_user_access?
    user_access = UserAccess.group_with_user(access_group, self)
    return false if user_access.nil?
    return user_access.can_crud_user_access
  end

  def can_see_locations_in_group?(access_group)
    user_access = UserAccess.group_with_user(access_group, self)
    return false if user_access.nil?
    return user_access.can_see_locations
  end

  def can_see_items_in_group?(access_group)
    user_access = UserAccess.group_with_user(access_group, self)
    return false if user_access.nil?
    return user_access.can_see_items
  end

  def can_see_location?(location)
    locations_with_visible_items.include?(location)
  end
  
  def is_sys_admin?
    UserPermission.find_by(user_id: self.id).is_sys_admin
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  # --------------------------------------------------------------

  def set_user_permissions(permissions=UserPermission::DEFAULT_PERMS)
    permissions = UserPermission.find_by(user_id: self.id)
    permissions.set_permissions
  end

  def set_user_access_permissions(access_group, permissions=UserAccess::DEFAULT_PERMS)
    user_access = UserAccess.where(user_id: self.id)
                .find_by(access_group_id: access_group.id)
    return nil if user_access.nil?
    user_access.set_permissions(permissions)
  end

  def activate
    update_attribute(:activated, true)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

 
  

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private
    def downcase_email
      email.downcase!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(self.activation_token)
    end

    def create_user_perms(permissions=UserPermission::DEFAULT_PERMS)
      permissions = UserPermission.new(user_id: self.id)
    end

    # def group_locations(group_array)
    #   locations = Hash.new
    #   group_array.each do |access_group|
    #     access_group.locations.each do |location|
    #       locations[location.id] ||= location
    #     end
    #   end
    #   return locations.values
    # end

end
