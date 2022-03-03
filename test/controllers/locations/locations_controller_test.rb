require 'test_helper'
class Locations::LocationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:U1)
    @admin_user.user_accesses << user_accesses(:UA1)
    @other_user = users(:U4)
    @access_group = access_groups(:AG1)
    @location = locations(:L1)
  end


  # --------------wrong user ------------
  test "should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Location.count' do
      post locations_path, params: {location: {name: "L5"}}
    end
    assert_not flash.empty?
    assert_redirected_to locations_path
  end

  test "Should redirect new if wrong user" do
    log_in_as(@other_user)
    get new_location_path
    assert_not flash.empty?
    assert_redirected_to locations_path
  end

  test "Should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Location.count' do
      delete location_path(@location)
    end
    assert_not flash.empty?
    assert_redirected_to locations_path
  end

  test "Should redirect show if wrong user" do
    log_in_as(@other_user)
    get location_path(@location)
    assert_not flash.empty?
    assert_redirected_to locations_path
  end

  test "Should redirect edit if wrong user" do
    log_in_as(@other_user)
    get edit_location_path(@location)
    assert_not flash.empty?
    assert_redirected_to locations_path
  end

  test "Should redirect update if wrong user" do
    log_in_as(@other_user)
    patch location_path(@location), params: {location: {name: "L5"}}
    assert_not flash.empty?
    assert_redirected_to locations_path
  end
  #--------------------------------------------------

  # ------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference 'Location.count' do
      post locations_path, params: {location: {name: "L5"}}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get new_location_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference 'Location.count' do
      delete location_path(@location)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect show if not logged in" do
    get location_path(@location)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit if not logged in" do
    get edit_location_path(@location)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update if not logged in" do
    patch location_path(@location), params: {location: {name: "L5"}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get locations_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------
  #-----------correct, logged in user----------------------
  test "new should get new locations view" do
    log_in_as(@admin_user)
    get new_location_path
    assert_response :success
  end

  test "should create new location with correct info" do
    log_in_as(@admin_user)
    assert_difference 'Location.count', 1 do
      post locations_path, params: {location: { name: "L10"}}
    end
    assert_redirected_to Location.find_by(name: "L10")
  end

  test "should not create new location with incorrect info" do
    log_in_as(@admin_user)
    assert_no_difference 'Location.count' do
      post locations_path, params: {location: {name: "        "}}
    end
    assert_redirected_to new_location_path
  end

  test "edit should get edit_location view" do
    log_in_as(@admin_user)
    get edit_location_path(@location)
    assert_response :success
  end

  test "should update location with correct info" do
    log_in_as(@admin_user)
    assert @location.name == "L1"
    patch location_path(@location), params: {location: {name: "L5"}}
    @location.reload
    assert @location.name == "L5"
    assert_redirected_to @location
  end

  test "should not update location with incorrect info" do
    log_in_as(@admin_user)
    assert @location.name == "L1"
    patch location_path(@access_group), params: {location: {name: "    "}}
    assert @location.name == "L1"
    assert_redirected_to edit_location_path(@location)
  end

  test "Should destroy location" do
    log_in_as(@admin_user)
    assert_difference 'Location.count', -1 do
      delete location_path(@location)
    end
    assert_redirected_to locations_path
  end

  test "index should show groups" do
    log_in_as(@admin_user)
    get locations_path
    assert_response :success
  end

  test "should show access group" do
    log_in_as(@admin_user)
    get location_path(@location)
    assert_response :success
  end
   #--------------------------------------------------
end