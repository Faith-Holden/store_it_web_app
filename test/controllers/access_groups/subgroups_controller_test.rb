require 'test_helper'
class AccessGroups::SubgroupsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:U1)
    @other_user = users(:U4)
    @access_group = AccessGroup.first
    @first_subgroup = access_groups(:AG3)
    @second_subgroup = access_groups(:AG4)
  end
  
  # ------------------wrong user ------------
  test "should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@access_group.subgroups.count" do
      post access_group_subgroups_path(@access_group), params: {subgroup_id: @second_subgroup.id}
    end
    assert_not flash.empty?
    assert_redirected_to access_group_subgroups_path(@access_group)
  end

  test "should redirect new if wrong user" do
    log_in_as(@other_user)
    get new_access_group_subgroup_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to access_group_subgroups_path(@access_group)
  end

  test "should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@access_group.subgroups.count" do
      delete access_group_subgroup_path(@access_group, @second_subgroup)
    end
    assert_not flash.empty?
    assert_redirected_to access_group_subgroups_path(@access_group)
  end
  #--------------------------------------------------

  # ------------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference "@access_group.subgroups.count" do
      post access_group_subgroups_path(@access_group), params: {subgroup_id: @second_subgroup.id}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get new_access_group_subgroup_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference "@access_group.subgroups.count" do
      delete access_group_location_path(@access_group, @second_subgroup)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get access_group_subgroups_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------


  #-----------correct, logged in user----------------------
  test "new should get new subgroups" do
    log_in_as @admin_user
    get new_access_group_subgroup_path(@access_group)
    assert_response :success
    assert_template :new
  end

  test "should add subgroup" do
    log_in_as @admin_user
    assert_difference "@access_group.subgroups.count", 1 do
      post access_group_subgroups_path(@access_group), params: {parent_id: @access_group.id, name: "Test"}
    end
    assert_redirected_to access_group_subgroups_path(@access_group)
  end

  test "should remove subgroup from group" do
    log_in_as @admin_user
    assert_difference "@access_group.subgroups.count", -1 do
      delete access_group_subgroup_path(@access_group, @first_subgroup)
    end
    assert_redirected_to access_group_subgroups_path(@access_group)
  end

  test "index should show subgroups in access_group" do
    log_in_as @admin_user
    get access_group_subgroups_path(@access_group)
    assert_response :success
  end
end