class UserAccess < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :access_group, dependent: :destroy

  scope :can_crud_subgroup, ->{ where("can_crud_subgroups == ?", true ) }
  scope :has_user, ->(user) {where(user_id: user.id)}
  scope :can_see_locations, ->{ where(can_see_locations: true) }
  scope :can_see_items, -> {where(can_see_items: true)}
  

  

  class << self
    # def user_can_crud_subgroup(user)
    #   where(user_id: user.id).where(can_crud_subgroups: true).pluck(:access_group_id)
    # end

    

  end
end
