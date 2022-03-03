require 'test_helper'
class Items::AccessGroupsControllerTest < ActionDispatch::IntegrationTest
 
  def setup
    @admin_user = users(:U1)
    @other_user = users(:U4)
    @item = items(:I1)
    @first_access_group = access_groups(:AG1)
    @first_access_group.add_item( @item)
    @second_access_group = access_groups(:AG2)
  end

  # ------------------wrong user ------------
  test "should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@item.access_groups.count" do
      post item_access_groups_path(@item), params: {access_group_id: @second_access_group.id}
    end
    assert_not flash.empty?
    assert_redirected_to item_path(@item)
  end

  test "should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference "@item.access_groups.count" do
      delete item_access_group_path(@item, @first_access_group)
    end
    assert_not flash.empty?
    assert_redirected_to item_path(@item)
  end
  #--------------------------------------------------

  # ------------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference "@item.access_groups.count" do
      post item_access_groups_path(@item), params: {access_group_id: @second_access_group.id}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get item_access_groups_path(@item)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference "@item.access_groups.count" do
      delete item_access_group_path(@item, @second_access_group)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get item_access_groups_path(@item)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------


  #-----------correct, logged in user----------------------
  test "new should get new item_access_group" do
    log_in_as @admin_user
    get new_item_access_group_path(@item)
    assert_response :success
    assert_template :new
  end

  test "should add item to group" do
    log_in_as @admin_user
    assert_difference "@item.access_groups.count", 1 do
      post item_access_groups_path(@item), params: {access_group_id: @second_access_group.id}
    end
    assert_redirected_to item_access_groups_path(@item)
  end

  test "should remove item from access_group" do
    log_in_as @admin_user
    assert_difference "@item.access_groups.count", -1 do
      delete item_access_group_path(@item, @first_access_group)
    end
    assert_redirected_to item_access_groups_path(@item)
  end

  test "index should show access_groups containing item" do
    log_in_as @admin_user
    get item_access_groups_path(@item)
    assert_response :success
  end
end