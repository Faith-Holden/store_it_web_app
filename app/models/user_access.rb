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

  ACCESS_LEVEL_NAMES = ["Group Admin","Default"]

  belongs_to :user
  belongs_to :access_group

  after_initialize :set_permissions, if: :new_record? 

  scope :can_crud_location_access, ->{ where(can_crud_location_access: true ) }
  scope :can_crud_subgroup, ->{ where(can_crud_subgroups: true ) }
  scope :can_crud_group, ->{ where(can_crud_group: true ) }
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
    def get_permission_level(permission)
      if permission == "Group Admin"
        return GROUP_ADMIN_PERMS
      elsif permission== "Default"
        return DEFAULT_PERMS
      else
        return nil
      end
    end

    def get_permission_name(permission)
      if permission == GROUP_ADMIN_PERMS
        "Group Admin"
      elsif permission == DEFAULT_PERMS
        "Default"
      else
        nil
      end
    end

    def get_permission_type(permission_record)
      permission_hash = {group_admin: permission_record.group_admin, can_see_group: permission_record.can_see_group,
        can_see_items: permission_record.can_see_items,can_see_locations: permission_record.can_see_locations, 
        can_crud_group: permission_record.can_crud_group, can_crud_user_access: permission_record.can_crud_user_access,
        can_crud_subgroups: permission_record.can_crud_subgroups, can_crud_location_access: permission_record.can_crud_location_access,
        can_crud_item_access: permission_record.can_crud_item_access}
      if permission_hash == GROUP_ADMIN_PERMS
        GROUP_ADMIN_PERMS
      elsif permission_hash == DEFAULT_PERMS
        DEFAULT_PERMS
      else
        nil
      end
    end

    def group_with_user(access_group, user)
      user_access_group = where(user_id: user.id)
      return nil if user_access_group.empty?
      return user_access_group.find_by(access_group_id: access_group.id)
    end
  end
end
