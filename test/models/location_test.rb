require "test_helper"

class LocationTest < ActiveSupport::TestCase
  def setup
    @location = Location.new(name: "Location", access_group_id: 1)
  end

  test "should be valid" do
    assert @location.valid?
  end

  test "name should be present" do
    @location.name = "    "
    assert_not @location.valid?
  end

  test "name should not be too long" do
    @location.name = "a" * 51
    assert_not @location.valid?
  end

  test "access group id should be present" do
    @location.access_group_id = "   "
    assert_not @location.valid?
  end
end
