class User < ApplicationRecord
  attr_accessor :activation_token

  has_one :user_permission
  has_many :user_accesses
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
  has_secure_password



  # returns an array of items that a user can see
  def items
    items = Hash.new
    locations = self.locations_with_visible_items
    locations.each do |location|
      location.items.each do |item|
        items[item.id] ||= item
      end
    end
    return items.values
  end

  def locations_with_visible_items
    group_locations(AccessGroup.with_user_visible_items_and_locations(self))
  end

  def can_see_location(location)
    locations_with_visible_items.include?(location)
  end

  # returns an array of locations that a user can see
  def locations
    group_locations(AccessGroup.with_user_visible_locations(self))
  end

  # def visible_child_locations(location)
  #   locations = self.locations
  #   child_locations = Location.child_locations(location)

  #   child_locations.each do |child_location|
  #     unless locations.include?(child_location)
  #       child_locations.delete(child_location)
  #     end
  #   end
  #   debugger
  #   return child_locations
  # end



  def can_crud_root_location?
    UserPermission.find_by(user_id: self.id).can_crud_locations_no_parent
  end
  
  def groups_user_can_crud_child
    AccessGroup.where(id: UserAccess.user_can_crud_subgroup(self))
  end

  def can_crud_root_group?
    UserPermission.find_by(user_id: self.id).can_crud_access_group_no_parent
  end

  def is_sys_admin?
    UserPermission.find_by(user_id: self.id).is_sys_admin
  end


  def activate
    update_attribute(:activated, true)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    
    BCrypt::Password.new(digest).is_password?(token)
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

    def group_locations(group_array)
      locations = Hash.new
      group_array.each do |access_group|
        access_group.locations.each do |location|
          locations[location.id] ||= location
        end
      end
      return locations.values
    end

end
