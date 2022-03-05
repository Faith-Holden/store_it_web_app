require "test_helper"

class AccessGroupTest < ActiveSupport::TestCase
  def setup
    @main_access_group = access_groups(:AG1)
  end

  test "should be valid" do
    first_new_access_group = AccessGroup.new(name: "Test Name")
    assert first_new_access_group.valid?
  end

  test "name should be present" do
    first_new_access_group = AccessGroup.new(name: "   ")
    assert_not first_new_access_group.valid?
  end

  test "name should not be too long" do
    new_access_group = AccessGroup.new(:name => "a" * 51)
    assert_not new_access_group.valid?
  end

  test "creates inherited user_accesses after create" do
    @sys_admin = users(:U1)
    @group_admin = users(:U2)
    @first_non_admin = users(:U3)
    @second_non_admin = users(:U4)

    assert @main_access_group.users.count == 4
    @child_group = AccessGroup.create(name: "child group", parent_id: @main_access_group.id)
    assert @child_group.users.count == 2
    assert_not @child_group.users.include?(@first_non_admin)
    assert_not @child_group.users.include?(@second_non_admin)
    assert @sys_admin.is_group_admin?(@child_group)
    assert @group_admin.is_group_admin?(@child_group)    
  end

  test "add_location adds location" do
    location_to_add = locations(:L1)
    assert_difference '@main_access_group.locations.count', 1 do
      @main_access_group.add_location(location_to_add)
    end
  end

  test "remove_location removes location" do
    location_to_remove = locations(:L6)
    assert_difference '@main_access_group.locations.count', -1 do
      @main_access_group.remove_location(location_to_remove)
    end
  end

  test "add_location_tree adds only location and visible sublocations" do
    user = users(:U2)
    parent_location_to_add = locations(:L1)
    assert_difference '@main_access_group.locations.count', 3 do
      @main_access_group.add_location_tree(user, parent_location_to_add)
    end
  end

  test "remove_location_tree removes location and all sublocations" do
    parent_location_to_remove = locations(:L1)
    user = users(:U2)
    access_group = access_groups(:AG2)
    assert_difference 'access_group.locations.count', -3 do
      access_group.remove_location_tree(parent_location_to_remove, user)
    end
  end

  test "add_location also adds items in location" do
    assert_difference '@main_access_group.items.count', 1 do
      @main_access_group.add_location(locations(:L1))
    end
  end

  
  test "remove_location also removes items in location" do
    assert_difference '@main_access_group.items.count', -1 do
      @main_access_group.remove_location(locations(:L5))
    end
  end


  test "add item with nil location adds item" do
    assert_difference '@main_access_group.items.count', 1 do
      @main_access_group.add_item(items(:I4))
    end
  end

  
  test "add item with location adds item" do
    assert_difference '@main_access_group.items.count', 1 do
      @main_access_group.add_item(items(:I3), locations(:L3))
    end
  end

  test "adding item already in group but new location should increment num_of_locations" do
    item_access = ItemsAccess.where(access_group_id: @main_access_group.id)&.find_by(item_id: items(:I1).id)
    assert item_access.num_of_locations == 2
    @main_access_group.add_location(locations(:L4))
    item_access.reload
    assert item_access.num_of_locations ==3
  end

  test "remove item with more than one location decrements num_of_locations" do
    item_access = ItemsAccess.where(access_group_id: @main_access_group.id)&.find_by(item_id: items(:I1).id)
    assert item_access.num_of_locations == 2
    @main_access_group.remove_location(locations(:L5))
    item_access.reload
    assert item_access.num_of_locations ==1
  end

  test "remove item with one or fewer locations removes item" do
    item_access = ItemsAccess.where(access_group_id: @main_access_group.id)&.find_by(item_id: items(:I2).id)
    item_access_id = item_access.id
    assert item_access.num_of_locations == 1
    @main_access_group.remove_location(locations(:L5))
    @main_access_group.items_accesses.reload
    assert @main_access_group.items_accesses.find_by(id: item_access_id).nil?
  end


  test "admin_users returns all admins" do
    manual_admins = Array.new 
    @main_access_group.users.each do |user|
      if user.is_group_admin?(@main_access_group) || user.is_sys_admin?
        manual_admins << user
      end
    end
    assert_not manual_admins.to_a.
                          difference(@main_access_group.admin_users)
                          .any?
  end

  test "admin_users does not return non-admins" do
    assert @main_access_group.admin_users.all?{|user| user.is_group_admin?(@main_access_group) || user.is_sys_admin?}
  end

  test "add_user should add user" do
    new_user = users(:U5)
    assert_not @main_access_group.users.include?(new_user)
    assert_difference '@main_access_group.users.count', 1 do
      @main_access_group.add_user(new_user)
    end
    assert @main_access_group.users.include?(new_user)
  end

  test "remove_user should remove user" do
    user_to_remove = users(:U1)
    assert @main_access_group.users.include?(user_to_remove)
    assert_difference '@main_access_group.users.count', -1 do
      @main_access_group.remove_user(user_to_remove)
    end
    assert_not @main_access_group.users.include?(user_to_remove)
  end

  test "with_user_visible_locations should only return ids of groups with visible locations" do
    user = users(:U2)
    ids = AccessGroup.with_user_visible_locations(user)
    user_accesses = UserAccess.where(access_group_id: ids)
                              &.has_user(user)
    assert user_accesses.to_a
                        .all? {|user_access| user_access.can_see_locations}
  end
  
  test "with_user_visible_items should only return ids of groups with visible items" do
    user = users(:U2)
    ids = AccessGroup.with_user_visible_items(user)
    user_accesses = UserAccess.where(access_group_id: ids)
                              &.has_user(user)
    assert user_accesses.to_a
                        .all? {|user_access| user_access.can_see_items}
  end

  test "with_user_visible_items_and_locations should only return ids of groups with visible items and locations" do
    user = users(:U2)
    ids = AccessGroup.with_user_visible_items_and_locations(user)
    user_accesses = UserAccess.where(access_group_id: ids)
                              &.has_user(user)
    assert user_accesses.to_a
                        .all? {|user_access| user_access.can_see_locations}
    assert user_accesses.to_a
                        .all? {|user_access| user_access.can_see_items}
  end

  test "visible_groups should only return ids of visible groups" do
    user = users(:U2)
    ids = AccessGroup.visible_groups(user)
    user_accesses = UserAccess.where(access_group_id: ids)
                              &.has_user(user)
    assert user_accesses.to_a
                        .all? {|user_access| user_access.can_see_group}
  end
  
  test "create_user_accesses should create accessess for each admin" do
    # currently, logic is covered in the test "creates inherited user_accesses after create"
  end
end
