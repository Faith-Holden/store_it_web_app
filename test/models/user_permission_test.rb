require "test_helper"

class UserPermissionTest < ActiveSupport::TestCase
  def setup
    @user = users(:U3)
  end

  test "set_permissions updates user_permission with correct permission" do
    assert_not @user.is_sys_admin?
    user_permission = UserPermission.find_by(user_id: @user.id)
    user_permission.set_permissions(UserPermission::SYS_ADMIN_PERMS)
    assert @user.is_sys_admin?
  end
end
