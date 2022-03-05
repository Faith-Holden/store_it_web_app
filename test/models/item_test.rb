require "test_helper"

class ItemTest < ActiveSupport::TestCase
  def setup
    @new_item = Item.new(name: "Item")
  end

  test "should be valid" do
    assert @new_item.valid?
  end

  test "name should be present" do
    @new_item.name = "    "
    assert_not @new_item.valid?
  end

  test "name should not be too long" do
    @new_item.name = "a" * 51
    assert_not @new_item.valid?
  end

  test "visible_locations should return all visible locations" do
    # user = users(:U2)
    # manual_locations = Array.new
    
    flunk "test is not yet written"
  end

  test "visible_locations should only return visible locations" do
    flunk "test is not yet written"
  end

  test "locationless? should only be only be true for items without location" do
    assert items(:I5).locationless?
    assert_not items(:I1).locationless?
  end

  test "set_item_location should create item_locations" do
    assert_difference 'ItemLocation.count', 1 do
      items(:I5).set_item_location(locations(:L1))
    end
  end
end
