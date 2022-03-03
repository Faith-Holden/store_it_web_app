require 'test_helper'
class Items::LocationsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:U1)
    @other_user = users(:U2)
    @item = items(:I1)
    @first_location = locations(:L1)
    @first_location.add_item( @item)
    @second_location = locations(:L2)
  end

  # ------------------wrong user ------------
  test "should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@item.locations.count" do
      post item_locations_path(@item), params: {location_id: @second_location.id}
    end
    assert_not flash.empty?
    assert_redirected_to item_path(@item)
  end

  test "should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@item.locations.count" do
      delete item_location_path(@item, @first_location)
    end
    assert_not flash.empty?
    assert_redirected_to item_path(@item)
  end
  #--------------------------------------------------

  # ------------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference "@item.locations.count" do
      post item_locations_path(@item), params: {location_id: @second_location.id}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get item_locations_path(@item)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference "@item.locations.count" do
      delete item_location_path(@item, @second_location)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get item_locations_path(@item)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------


  #-----------correct, logged in user----------------------
  test "new should get new item_location" do
    log_in_as @admin_user
    get new_item_location_path(@item)
    assert_response :success
    assert_template :new
  end

  test "should add item to location" do
    log_in_as @admin_user
    assert_difference "@item.locations.count", 1 do
      post item_locations_path(@item), params: {location_id: @second_location.id}
    end
    assert_redirected_to item_locations_path(@item)
  end

  test "should not add item if already in location" do
    log_in_as @admin_user
    assert_no_difference "@item.locations.count" do
      post item_locations_path(@item), params: {location_id: @first_location.id}
    end
    assert_redirected_to item_locations_path(@item)
  end

  test "should remove item from location" do
    log_in_as @admin_user
    assert_difference "@item.locations.count", -1 do
      delete item_location_path(@item, @first_location)
    end
    assert_redirected_to item_locations_path(@item)
  end

  test "index should show locations containing item" do
    log_in_as @admin_user
    get item_locations_path(@item)
    assert_response :success
  end
end