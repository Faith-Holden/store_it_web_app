require "test_helper"

class ItemsAccessTest < ActiveSupport::TestCase

  def setup
    @item_access = items_accesses(:IA1)
  end


  test "decrement should decrease location count" do
    assert_difference '@item_access.num_of_locations', -1 do
      @item_access.decrement_locations
    end
  end

  test "increment should decrease location count" do
    assert_difference '@item_access.num_of_locations', 1 do
      @item_access.increment_locations
    end
  end
end
