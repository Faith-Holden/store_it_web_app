class UserAccess < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :access_group, dependent: :destroy

  scope :can_crud_subgroup, ->{ where(can_crud_subgroups: true ) }
  scope :has_user, ->(user) {where(user_id: user.id)}
  scope :can_see_locations, ->{ where(can_see_locations: true) }
  scope :can_see_group, -> { where(can_see_group: true)}
  scope :can_see_items, -> {where(can_see_items: true)}  

  

  class << self
    def group_with_user(access_group, user)
      user_access_group = where(user_id: user.id)
      return nil if user_access_group.empty?
      return user_access_group.find_by(access_group_id: access_group.id)
    end
  end
end
