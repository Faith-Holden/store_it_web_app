require 'test_helper'
class Locations::AccessGroupsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:U1)
    @other_user = users(:U4)
    @first_access_group = access_groups(:AG1)
    @third_group = access_groups(:AG3)
    @location = locations(:L1)
    @first_access_group.add_location(@location)
  end

  # ------------------wrong user ------------
  test "should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@location.access_groups.count" do
      post location_access_groups_path(@location), params: {access_group_id: @third_group.id}
    end
    assert_not flash.empty?
    assert_redirected_to location_access_groups_path(@location)
  end
  
  test "should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@location.access_groups.count" do
      delete location_access_group_path(@location, @first_access_group)
    end
    assert_not flash.empty?
    assert_redirected_to location_access_groups_path(@location)
  end
  #--------------------------------------------------

  # ------------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference "@location.access_groups.count" do
      post location_access_groups_path(@location), params: {access_group_id: @third_group.id}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get new_access_group_location_path(@location)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference "@location.access_groups.count" do
      delete location_access_group_path(@location, @third_group)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get location_access_groups_path(@location)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------


  #-----------correct, logged in user----------------------
  test "new should get new location_access_groups" do
    log_in_as @admin_user
    get new_location_access_group_path(@location)
    assert_response :success
    assert_template :new
  end

  test "should add location to access_group" do
    log_in_as @admin_user
    assert_difference "@location.access_groups.count", 1 do
      post location_access_groups_path(@location), params: {access_group_id: @third_group.id}
    end
    assert_redirected_to location_access_groups_path(@location)
  end

  test "should not add location if already in group" do
    log_in_as @admin_user
    assert_no_difference "@location.access_groups.count" do
      post location_access_groups_path(@location), params: {access_group_id: @first_access_group.id}
    end
    assert_redirected_to location_access_groups_path(@location)
  end

  test "should remove location from group" do
    log_in_as @admin_user
    assert_difference "@location.access_groups.count", -1 do
      delete location_access_group_path(@location, @first_access_group)
    end
    assert_redirected_to location_access_groups_path(@location)
  end

  test "index should show locations in access_group" do
    log_in_as @admin_user
    get location_access_groups_path(@location)
    assert_response :success
  end
end