require "test_helper"

class UserAccessTest < ActiveSupport::TestCase
  def setup
    @access_group = access_groups(:AG1)
    @user = users(:U3)
  end



  test "set_permissions updates user_access with correct permission" do
    assert_not @user.is_group_admin?(@access_group)
    user_access = UserAccess.where(user_id: @user.id)
                            &.find_by(access_group_id: @access_group.id)
    user_access.set_permissions(UserAccess::GROUP_ADMIN_PERMS)
    assert @user.is_group_admin?(@access_group)
  end

  test "group_with_user returns correct user_access" do
    user_access = UserAccess.where(user_id: @user.id)
                            &.find_by(access_group_id: @access_group.id)
    assert user_access = UserAccess.group_with_user(@access_group, @user)
  end

end
