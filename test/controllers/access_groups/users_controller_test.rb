require 'test_helper'
class AccessGroups::UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin_user = users(:U1)
    @other_user = users(:U4)
    @access_group = AccessGroup.first
    @first_new_user = users(:U5)
    @second_new_user = users(:U6)
    @access_group.add_user(@first_new_user)
  end

  
   # ------------------wrong user ------------
   test "should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@access_group.users.count" do
      post access_group_users_path(@access_group), params: {user_id: @second_new_user.id}
    end
    assert_not flash.empty?
    assert_redirected_to access_group_path(@access_group)
  end

  test "should redirect new if wrong user" do
    log_in_as(@other_user)
    get new_access_group_user_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to access_group_path(@access_group)
  end

  test "should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@access_group.users.count" do
      delete access_group_user_path(@access_group, @second_new_user)
    end
    assert_not flash.empty?
    assert_redirected_to access_group_path(@access_group)
  end

  test "should redirect index if wrong user" do
    log_in_as(@other_user)
    get access_group_users_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to access_group_path(@access_group)
  end
  #--------------------------------------------------

  # ------------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference "@access_group.users.count" do
      post access_group_users_path(@access_group), params: {user_id: @second_new_user.id}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get new_access_group_user_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference "@access_group.users.count" do
      delete access_group_user_path(@access_group, @first_new_user)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get access_group_users_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------

  #-----------correct, logged in user----------------------
  test "new should get new access_group_user" do
    log_in_as @admin_user
    get new_access_group_user_path(@access_group)
    assert_response :success
    assert_template :new
  end

  test "should add user" do
    log_in_as @admin_user
    assert_difference "@access_group.users.count", 1 do
      post access_group_users_path(@access_group), params: {user_id: @second_new_user.id}
    end
    assert_redirected_to access_group_users_path(@access_group)
  end

  test "should not add user already in group" do
    log_in_as @admin_user
    assert_no_difference "@access_group.users.count" do
      post access_group_users_path(@access_group), params: {user_id: @first_new_user.id}
    end
    assert_redirected_to access_group_users_path(@access_group)
  end

  test "should remove user from group" do
    log_in_as @admin_user
    assert_difference "@access_group.users.count", -1 do
      delete access_group_user_path(@access_group, @first_new_user)
    end
    assert_redirected_to access_group_users_path(@access_group)
  end

  test "index should show users in access_group" do
    log_in_as @admin_user
    get access_group_users_path(@access_group)
    assert_response :success
  end
end