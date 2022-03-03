require 'test_helper'
class AccessGroups::ItemsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:U1)
    @other_user = users(:U4)
    @access_group = AccessGroup.first
    @first_item = items(:I1)
    @second_item = items(:I2)
    @access_group.add_item( @first_item)
  end

  # ------------------wrong user ------------
  test "should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@access_group.items.count" do
      post access_group_items_path(@access_group), params: {item_id: @second_item.id}
    end
    assert_not flash.empty?
    assert_redirected_to access_group_items_path(@access_group)
  end

  test "should redirect new if wrong user" do
    log_in_as(@other_user)
    get new_access_group_item_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to access_group_items_path(@access_group)
  end

  test "should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@access_group.items.count" do
      delete access_group_item_path(@access_group, @second_item)
    end
    assert_not flash.empty?
    assert_redirected_to access_group_items_path(@access_group)
  end

  test "should redirect index if wrong user" do
    log_in_as(@other_user)
    get access_group_items_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to access_group_path(@access_group)
  end
  #--------------------------------------------------

  # ------------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference "@access_group.items.count" do
      post access_group_items_path(@access_group), params: {item_id: @second_item.id}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get new_access_group_item_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference "@access_group.items.count" do
      delete access_group_item_path(@access_group, @second_item)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get access_group_items_path(@access_group)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------


  #-----------correct, logged in user----------------------
  test "new should get new access_group_items" do
    log_in_as @admin_user
    get new_access_group_item_path(@access_group)
    assert_response :success
    assert_template :new
  end

  test "should add item" do
    log_in_as @admin_user
    assert_difference "@access_group.items.count", 1 do
      post access_group_items_path(@access_group), params: {item_id: @second_item.id}
    end
    assert_redirected_to access_group_items_path(@access_group)
  end

  test "should not add item already in group" do
    log_in_as @admin_user
    assert_no_difference "@access_group.items.count" do
      post access_group_items_path(@access_group), params: {item_id: @first_item.id}
    end
    assert_redirected_to access_group_items_path(@access_group)
  end

  test "should remove item from group" do
    log_in_as @admin_user
    assert_difference "@access_group.items.count", -1 do
      delete access_group_item_path(@access_group, @first_item)
    end
    assert_redirected_to access_group_items_path(@access_group)
  end

  test "index should show items in access_group" do
    log_in_as @admin_user
    get access_group_items_path(@access_group)
    assert_response :success
  end
end