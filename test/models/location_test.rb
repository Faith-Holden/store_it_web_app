require "test_helper"

class LocationTest < ActiveSupport::TestCase
  def setup
    @location = Location.new(name: "Location")
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

  test "add_sublocation should add proper sublocation" do
    flunk "test is not yet written"
  end

  test "destroy_location should change nullify sublocations parent and destroy location" do
    flunk "test is not yet written"
  end

  test "add_item should add item" do
    flunk "test is not yet written"
  end

  test "visible_sublocations should be visible to admin" do
    flunk "test is not yet written"
  end

  test "visible_sublocations should only show correct locations" do
    flunk "test is not yet written"
  end

  test "root_visible_ancester? should be true if parent is nil" do
    flunk "test is not yet written"
  end

  test "root_visible_ancester? should be true if parent is invisible" do
    flunk "test is not yet written"
  end

  test "is_visible? should be true if user is admin" do
    flunk "test is not yet written"
  end

  test "is_visible? should be true only if user can see location" do
    flunk "test is not yet written"
  end

  test "visible_groups should return all of locations visible groups" do
    flunk "test is not yet written"
  end

  test "locations in groups should return all locations in all specified access groups" do
    flunk "test is not yet written"
  end

end
