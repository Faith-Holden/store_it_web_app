require "test_helper"

class ItemTest < ActiveSupport::TestCase
  def setup
    @item = Item.new(name: "Item", access_group_id: 1)
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

  test "access group id should be present" do
    @item.access_group_id = "   "
    assert_not @item.valid?
  end
end
