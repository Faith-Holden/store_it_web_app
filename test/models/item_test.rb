require "test_helper"

class ItemTest < ActiveSupport::TestCase
  def setup
    @item = Item.new(name: "Item")
  end

  test "should be valid" do
    assert @item.valid?
  end

  test "name should be present" do
    @item.name = "    "
    assert_not @item.valid?
  end

  test "name should not be too long" do
    @item.name = "a" * 51
    assert_not @item.valid?
  end

  test "image should be valid" do
    flunk "test is not yet written"
  end

  test "visible_locations should only return visible locations" do
    flunk "test is not yet written"
  end

  test "locationless? should only return items without location" do
    flunk "test is not yet written"
  end

  test "add_to_location should add item to location" do
    flunk "test is not yet written"
  end

  test "set_item_location should create item_locations" do
    flunk "test is not yet written"
  end
end
