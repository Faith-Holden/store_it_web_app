class UserPermission < ApplicationRecord
  belongs_to :user
  after_initialize :set_permissions, if: :new_record? 

 # These constants could be changed/added to/removed for different servers
  SYS_ADMIN_PERMS = {is_sys_admin: true, can_crud_items: true,
                     can_crud_locations_with_parent: true, can_crud_locations_no_parent: true,
                     can_crud_access_group_no_parent: true}
  GROUP_ADMIN_PERMS = {is_sys_admin: false, can_crud_items: true,
                      can_crud_locations_with_parent: true, can_crud_locations_no_parent: true,
                      can_crud_access_group_no_parent: false}
  DEFAULT_PERMS ={is_sys_admin: false, can_crud_items: true,
                      can_crud_locations_with_parent: false, can_crud_locations_no_parent: false,
                      can_crud_access_group_no_parent: false}




  def set_permissions(permissions=DEFAULT_PERMS)
    self.update!(permissions)
  end
end
