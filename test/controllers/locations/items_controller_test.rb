require 'test_helper'
class Locations::ItemsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:U1)
    @other_user = users(:U4)
    @first_item = items(:I1)
    @second_item = items(:I2)
    @location = locations(:L1)
    @location.add_item(@first_item)
  end

  
  # ------------------wrong user ------------
  test "should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@location.items.count" do
      post location_items_path(@location), params: {item_id: @second_item.id}
    end
    assert_not flash.empty?
    assert_redirected_to location_items_path(@location)
  end

  test "should redirect new if wrong user" do
    log_in_as(@other_user)
    get new_location_item_path(@location)
    assert_not flash.empty?
    assert_redirected_to location_items_path(@location)
  end

  test "should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@location.items.count" do
      delete location_item_path(@location, @first_item)
    end
    assert_not flash.empty?
    assert_redirected_to location_items_path(@location)
  end

  test "should redirect index if wrong user" do
    log_in_as(@other_user)
    get location_items_path(@location)
    assert_not flash.empty?
    assert_redirected_to location_path(@location)
  end
  #--------------------------------------------------

  # ------------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference "@location.items.count" do
      post location_items_path(@location), params: {item_id: @second_item.id}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get new_location_item_path(@location)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference "@location.items.count" do
      delete location_item_path(@location, @second_item)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get location_items_path(@location)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------


  #-----------correct, logged in user----------------------
  test "new should get new location_item" do
    log_in_as @admin_user
    get new_location_item_path(@location)
    assert_response :success
    assert_template :new
  end

  test "should add item to location" do
    log_in_as @admin_user
    assert_difference "@location.items.count", 1 do
      post location_items_path(@location), params: {item_id: @second_item.id}
    end
    assert_redirected_to location_items_path(@location)
  end

  test "should not add item already in location" do
    log_in_as @admin_user
    assert_no_difference "@location.items.count" do
      post location_items_path(@location), params: {item_id: @first_item.id}
    end
    assert_redirected_to location_items_path(@location)
  end

  test "should remove item from location" do
    log_in_as @admin_user
    assert_difference "@location.items.count", -1 do
      delete location_item_path(@location, @first_item)
    end
    assert_redirected_to location_items_path(@location)
  end

  test "index should show items in location" do
    log_in_as @admin_user
    get location_items_path(@location)
    assert_response :success
  end
end