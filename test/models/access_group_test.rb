require "test_helper"

class AccessGroupTest < ActiveSupport::TestCase
  def setup
    @access_group = AccessGroup.new(name: "Test Name")
  end

  test "should be valid" do
    assert @access_group.valid?
  end

  test "name should be present" do
    @access_group.name = "    "
    assert_not @access_group.valid?
  end

  test "name should not be too long" do
    @access_group.name = "a" * 51
    assert_not @access_group.valid?
  end

  test "creates user_accesses after create" do
    flunk ' test not written yet.'
  end

  test "add_location adds location" do
    flunk ' test not written yet.'
  end

  test "remove_location removes a location" do
    flunk ' test not written yet.'
  end

  test "add_location_tree adds location and sublocations" do
    flunk ' test not written yet.'
  end

  test "add_location_tree only adds viewable sublocations" do
    flunk ' test not written yet.'
  end

  test "remove_location_tree removes location and all sublocations" do
    flunk ' test not written yet.'
  end

  test "add item with nil location" do
    flunk ' test not written yet.'
  end

  test "add item with location" do
    flunk ' test not written yet.'
  end

  test "remove item removes item" do
    flunk ' test not written yet.'
  end

  test "admin_users returns all admins" do
    flunk ' test not written yet.'
  end

  test "admin_users does not return non-admins" do
    flunk ' test not written yet.'
  end

  test "add_user should add user" do
    flunk ' test not written yet.'
  end

  test "with_user_visible_locations should only return ids of groups with visible locations" do
    flunk ' test not written yet.'
  end
  
  test "with_user_visible_items should only return ids of groups with visible items" do
    flunk ' test not written yet.'
  end

  test "with_user_visible_items_and_locations should only return ids of groups with visible items and locations" do
    flunk ' test not written yet.'
  end

  test "visible_groups should only return ids of visible groups" do
    flunk ' test not written yet.'
  end
  
  test "create_user_accesses should create accessess for each admin" do
    flunk ' test not written yet.'
  end
end
