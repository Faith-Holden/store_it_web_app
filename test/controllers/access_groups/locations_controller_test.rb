require 'test_helper'
class AccessGroups::LocationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:U1)
    @other_user = users(:U4)
    @access_group = AccessGroup.first
    @first_location = locations(:L1)
    @second_location = locations(:L2)
    @fourth_location = locations(:L4)
    @access_group.add_location(@first_location)
  end

  # ------------------wrong user ------------
  test "should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@access_group.locations.count" do
      post access_group_locations_path(@access_group), params: {location_id: @second_location.id}
    end
    assert_not flash.empty?
    assert_redirected_to access_group_locations_path(@access_group)
  end

  test "should redirect new if wrong user" do
    log_in_as(@other_user)
    get new_access_group_location_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to access_group_locations_path(@access_group)
  end

  test "should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@access_group.locations.count" do
      delete access_group_location_path(@access_group, @first_location)
    end
    assert_not flash.empty?
    assert_redirected_to access_group_locations_path(@access_group)
  end

  test "should redirect index if wrong user" do
    log_in_as(@other_user)
    get access_group_locations_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to access_group_path(@access_group)
  end
  #--------------------------------------------------

  # ------------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference "@access_group.locations.count" do
      post access_group_locations_path(@access_group), params: {location_id: @second_location.id}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get new_access_group_location_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference "@access_group.locations.count" do
      delete access_group_location_path(@access_group, @second_location)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get access_group_locations_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------


  #-----------correct, logged in user----------------------
  test "new should get new access_group_locations" do
    log_in_as @admin_user
    get new_access_group_location_path(@access_group)
    assert_response :success
    assert_template :new
  end

  test "should add location without children" do
    log_in_as @admin_user
    assert_difference "@access_group.locations.count", 1 do
      post access_group_locations_path(@access_group), params: {location_id: @fourth_location.id}
    end
    assert_redirected_to access_group_locations_path(@access_group)
  end

  test "should add location with children" do
    log_in_as @admin_user
    assert_difference "@access_group.locations.count", 2 do
      # second_location has 2 descendants
      post access_group_locations_path(@access_group), params: {location_id: @second_location.id}
    end
    assert_redirected_to access_group_locations_path(@access_group)
  end

  test "should not add location already in group" do
    log_in_as @admin_user
    assert_no_difference "@access_group.locations.count" do
      post access_group_locations_path(@access_group), params: {location_id: 6}
    end
    assert_redirected_to access_group_locations_path(@access_group)
  end

  test "should remove location from group" do
    log_in_as @admin_user
    assert_difference "@access_group.locations.count", -1 do
      delete access_group_location_path(@access_group, @first_location)
    end
    assert_redirected_to access_group_locations_path(@access_group)
  end

  test "index should show locations in access_group" do
    log_in_as @admin_user
    get access_group_locations_path(@access_group)
    assert_response :success
  end
end