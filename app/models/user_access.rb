class UserAccess < ApplicationRecord
  # These constants could be changed/added to/removed for different servers
  SYS_ADMIN_PERMS = {group_admin: true, can_see_group: true, can_see_items: true,
                     can_see_locations: true, can_crud_group: true, can_crud_user_access: true,
                     can_crud_subgroups: true, can_crud_location_access: true,
                     can_crud_item_access: true}
  GROUP_ADMIN_PERMS = {group_admin: true, can_see_group: true, can_see_items: true,
                      can_see_locations: true, can_crud_group: true, can_crud_user_access: true,
                      can_crud_subgroups: true, can_crud_location_access: true,
                      can_crud_item_access: true}
  DEFAULT_PERMS = {group_admin: false, can_see_group: true, can_see_items: true,
                      can_see_locations: true, can_crud_group: false, can_crud_user_access: false,
                      can_crud_subgroups: false, can_crud_location_access: false,
                      can_crud_item_access: false}


  belongs_to :user
  belongs_to :access_group

  after_initialize :set_permissions, if: :new_record? 

  scope :can_crud_location_access, ->{ where(can_crud_location_access: true ) }
  scope :can_crud_subgroup, ->{ where(can_crud_subgroups: true ) }
  scope :can_crud_group, ->{ where(can_crud_groups: true ) }
  scope :can_crud_item_access, ->{ where(can_crud_item_access: true ) }
  scope :is_group_admin, ->{where(group_admin: true)}
  scope :has_user, ->(user) {where(user_id: user.id)}
  scope :can_see_locations, ->{ where(can_see_locations: true) }
  scope :can_see_group, -> { where(can_see_group: true)}
  scope :can_see_items, -> {where(can_see_items: true)}  

  
  def set_permissions(permissions=DEFAULT_PERMS)
    self.update!(permissions)
  end

  class << self
    def group_with_user(access_group, user)
      user_access_group = where(user_id: user.id)
      return nil if user_access_group.empty?
      return user_access_group.find_by(access_group_id: access_group.id)
    end
  end
end
