require "test_helper"

class LocationTest < ActiveSupport::TestCase
  def setup
    @new_location = Location.new(name: "Location")
  end

  test "should be valid" do
    assert @new_location.valid?
  end

  test "name should be present" do
    @new_location.name = "    "
    assert_not @new_location.valid?
  end

  test "name should not be too long" do
    @new_location.name = "a" * 51
    assert_not @new_location.valid?
  end

  test "add_sublocation should add sublocation" do
    sublocation = locations(:L5)
    parent_location = locations(:L4)
    assert sublocation.parent_id.nil?
    assert_difference 'parent_location.sublocations.count', 1 do
      parent_location.add_sublocation(sublocation)
    end
    sublocation.reload
    assert sublocation.parent_id == parent_location.id
  end

  test "destroy_location should nullify sublocations parent and destroy location" do
    sublocation = locations(:L2)
    parent_location = locations(:L1)
    assert_not sublocation.parent_id.nil?
    assert_difference 'Location.count', -1 do
      parent_location.destroy_location
    end
    sublocation.reload
    assert sublocation.parent_id.nil?
  end

  test "add_item should add item" do
    location = locations(:L1)
    item = items(:I5)
    assert_not location.items.include?(item)
    assert_difference 'location.items.count', 1 do
      location.add_item(item)
    end
    assert location.items.include?(item)
  end

  test "visible_sublocations should show all sublocations for admin" do
    location = locations(:L1)
    user = users(:U1)
    assert location.sublocations.count == location.visible_sublocations(user).count
  end

  test "visible_sublocations should only show user visble locations" do
    parent_location = locations(:L1)
    user = users(:U4)
    visible_sublocations = parent_location.visible_sublocations(user)
    assert parent_location.sublocations.count > visible_sublocations.count
    assert visible_sublocations.all?{|sublocation| sublocation.is_visible?(user)}
  end

  test "root_visible_ancestor? should be true if parent is nil" do
    user = users(:U1)
    assert locations(:L1).root_visible_ancestor?(user)
    assert locations(:L5).root_visible_ancestor?(user)
    assert_not locations(:L2).root_visible_ancestor?(user)
  end

  test "root_visible_ancestor? should be true if parent is invisible" do
    location = locations(:L2)
    user = users(:U7)
    assert location.root_visible_ancestor?(user)
  end

  test "is_visible? should be true if user is admin" do
    location = locations(:L6)
    user = users(:U1)
    assert location.is_visible?(user)
  end

  test "is_visible? should not be true if user can see location" do
    location = locations(:L1)
    user = users(:U7)
    assert_not location.is_visible?(user)
  end

  test "visible_groups should return all visible groups for location" do
    location = locations(:L2)
    user = users(:U7)
    visible_count = 0
    visible_groups = AccessGroup.visible_groups(user)

    location.access_groups.each do |group|
      if visible_groups.include?(group.id)
        visible_count += 1
      end
    end
    
    assert location.visible_groups(user).count == visible_count
  end

  test "locations in groups should return all locations in all specified access group" do
    access_groups = [access_groups(:AG1), access_groups(:AG2), access_groups(:AG3)]
    access_group_ids = Array.new
    manual_locations = Array.new
    access_groups.each do |group|
      group.locations.each do |location|
        unless manual_locations.include?(location)
          manual_locations << location
        end
      end
      access_group_ids << group.id
    end
    result_of_locations_in_groups = Location.locations_in_groups(access_group_ids).to_a
    assert_not result_of_locations_in_groups.difference(manual_locations).any?
  end

end
