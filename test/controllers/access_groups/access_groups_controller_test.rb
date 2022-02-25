require 'test_helper'
class AccessGroups::AccessGroupsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:U1)
    @admin_user.user_accesses << user_accesses(:UA1)
    @other_user = users(:U2)
    @access_group = AccessGroup.first
  end


  # --------------wrong user ------------
  test "Should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'AccessGroup.count' do
      post access_groups_path, params: {access_group: {name: "AG5"}}
    end
    assert_not flash.empty?
    assert_redirected_to access_groups_path
  end

  test "Should redirect new if wrong user" do
    log_in_as(@other_user)
    get new_access_group_path
    assert_not flash.empty?
    assert_redirected_to access_groups_path
  end

  test "Should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'AccessGroup.count' do
      delete access_group_path(@access_group)
    end
    assert_not flash.empty?
    assert_redirected_to access_groups_path
  end

  test "Should redirect show if wrong user" do
    log_in_as(@other_user)
    get access_group_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to access_groups_path
  end

  test "Should redirect edit if wrong user" do
    log_in_as(@other_user)
    get edit_access_group_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to access_groups_path
  end

  test "Should redirect update if wrong user" do
    log_in_as(@other_user)
    post access_groups_path(@access_group), params: {access_group: {name: "AG5"}}
    assert_not flash.empty?
    assert_redirected_to access_groups_path
  end
  #--------------------------------------------------

  # ------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference 'AccessGroup.count' do
      post access_groups_path, params: {access_group: {name: "AG5"}}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get new_access_group_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference 'AccessGroup.count' do
      delete access_group_path(@access_group)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect show if not logged in" do
    get access_group_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit if not logged in" do
    get edit_access_group_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update if not logged in" do
    post access_groups_path(@access_group), params: {access_group: {name: "AG5"}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get access_groups_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------
  #-----------correct, logged in user----------------------
  test "new should get new access groups view" do
    log_in_as(@admin_user)
    get new_access_group_path
    assert_response :success
  end

  test "should create new access group with correct info" do
    log_in_as(@admin_user)
    assert_difference 'AccessGroup.count', 1 do
      post access_groups_path, params: {access_group: { name: "AG5"}}
    end
    assert_redirected_to AccessGroup.find_by(name: "AG5")
  end

  test "should not create new access group with incorrect info" do
    log_in_as(@admin_user)
    assert_no_difference 'AccessGroup.count' do
      post access_groups_path, params: {access_group: {name: "        "}}
    end
    assert_redirected_to new_access_group_path
  end

  test "edit should get edit_access_groups view" do
    log_in_as(@admin_user)
    get edit_access_group_path(@access_group)
    assert_response :success
  end

  test "should update access group with correct info" do
    log_in_as(@admin_user)
    assert @access_group.name == "AG1"
    patch access_group_path(@access_group), params: {access_group: {name: "AG5"}}
    @access_group.reload
    assert @access_group.name == "AG5"
    assert_redirected_to @access_group
  end

  test "should not update access group with incorrect info" do
    log_in_as(@admin_user)
    assert @access_group.name == "AG1"
    patch access_group_path(@access_group), params: {access_group: {name: "    "}}
    assert @access_group.name == "AG1"
    assert_redirected_to access_groups_path(@access_group)
  end

  test "Should destroy access group" do
    log_in_as(@admin_user)
    assert_difference 'AccessGroup.count', -1 do
      delete access_group_path(@access_group)
    end
    assert_redirected_to access_groups_path
  end

  test "index should show groups" do
    log_in_as(@admin_user)
    get access_groups_path
    assert_response :success
  end

  test "should show access group" do
    log_in_as(@admin_user)
    get access_group_path(@access_group)
    assert_response :success
  end
   #--------------------------------------------------
end