require 'test_helper'
class Locations::SublocationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:U1)
    @other_user = users(:U4)
    @location = locations(:L1)
    @first_sublocation = locations(:L2)
    @second_sublocation = locations(:L3)
  end
  
  # ------------------wrong user ------------
  test "should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@location.sublocations.count" do
      post location_sublocations_path(@location), params: {sublocation_id: @second_sublocation.id}
    end
    assert_not flash.empty?
    assert_redirected_to location_sublocations_path(@location)
  end

  test "should redirect new if wrong user" do
    log_in_as(@other_user)
    get new_location_sublocation_path(@location)
    assert_not flash.empty?
    assert_redirected_to location_sublocations_path(@location)
  end

  test "should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@location.sublocations.count" do
      delete location_sublocation_path(@location, @second_sublocation)
    end
    assert_not flash.empty?
    assert_redirected_to location_sublocations_path(@location)
  end
  #--------------------------------------------------

  # ------------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference "@location.sublocations.count" do
      post location_sublocations_path(@location), params: {sublocation_id: @second_sublocation.id}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get new_location_sublocation_path(@location)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference "@location.sublocations.count" do
      delete location_sublocation_path(@location, @first_sublocation)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get location_sublocations_path(@location)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------


  #-----------correct, logged in user----------------------
  test "new should get new sublocation" do
    log_in_as @admin_user
    get new_location_sublocation_path(@location)
    assert_response :success
    assert_template :new
  end

  test "should add sublocation" do
    log_in_as @admin_user
    assert_difference "@location.sublocations.count", 1 do
      post location_sublocations_path(@location), params: {parent_id: @location.id, name: "Test"}
    end
    assert_redirected_to location_sublocations_path(@location)
  end

  test "should remove sublocation from location" do
    log_in_as @admin_user
    assert_difference "@location.sublocations.count", -1 do
      delete location_sublocation_path(@location, @first_sublocation)
    end
    assert_redirected_to location_sublocations_path(@location)
  end

  test "index should show sublocations in location" do
    log_in_as @admin_user
    get location_sublocations_path(@location)
    assert_response :success
  end
end