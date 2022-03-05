require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @new_user = User.new(name: "User Name", email: "test@email.com", password: "foobar")
  end

  test "should be valid" do
    assert @new_user.valid?
  end

  test "name should be present" do
    @new_user.name = "    "
    assert_not @new_user.valid?
  end

  test "name should not be too long" do
    @new_user.name = "a" * 51
    assert_not @new_user.valid?
  end

  test "email should be present" do
    @new_user.email = "    "
    assert_not @new_user.valid?
  end

  test "email should not be too long" do
    @new_user.email = "a" * 201
    assert_not @new_user.valid?
  end

  test "sys admin should see all items" do
    user = users(:U1)
    assert user.is_sys_admin?
    assert user.items.count == Item.count
  end

  test "non-admin should see only restricted items" do
    user = users(:U4)
    assert_not user.is_sys_admin?
    user_items = user.items
    user_access_groups = user.access_groups.to_a

    assert user_items.count < Item.count
    items_are_correct = true
    user_items.each do |item|
      if item.access_groups.none?{|group| user_access_groups.include?(group)}
        items_are_correct = false
        break
      end
    end
  end

  test "visible_ancestor_locations gets all location ancestors user can see" do
    user = users(:U3)
    ancestors = user.visible_ancestor_locations
    correct_result = true
    ancestors.each do |location|
      correct_result = location.is_root_visible_ancestor?(user)
      unless correct_result
        break
      end
    end
    assert correct_result
  end

  test "visible_access_groups should get all groups user has view access in" do
    user = users(:U3)
    visible_groups = user.visible_access_groups.to_a
    user_accesses = UserAccess.has_user(user)
                              &.can_see_group
                              .to_a
    assert_not visible_groups.difference(user_accesses).any?
  end

  test "should get all locations that are visible and have visible items for user" do
    flunk "test is not yet written"
  end

  test "all locations should be visible to sys admin" do
    flunk "test is not yet written"
  end

  test "should return location in groups where user can see locations" do
    flunk "test is not yet written"
  end

  test "sys admin should be able to crud subgroups" do
    flunk "test is not yet written"
  end

  test "group admin should be able to crud subgroups in specified groups" do
    flunk "test is not yet written"
  end

  test "user with permission should be able to crud subgroups in specified groups" do
    flunk "test is not yet written"
  end

  test "sys admin should be able to crud locations in groups" do
    flunk "test is not yet written"
  end

  test "group admin should be able to crud locations in groups" do
    flunk "test is not yet written"
  end

  test "user with permission should be able to crud locations in groups" do
    flunk "test is not yet written"
  end

  test "sys admin should be able to crud items in groups" do
    flunk "test is not yet written"
  end

  test "group admin should be able to crud items in groups" do
    flunk "test is not yet written"
  end

  test "user with permission should be able to crud items in groups" do
    flunk "test is not yet written"
  end


  test "sys admin should be able to crud items" do
    flunk "test is not yet written"
  end

  test "user with permission should be able to crud items" do
    flunk "test is not yet written"
  end

  test "sys admin should be able to crud root locations" do
    flunk "test is not yet written"
  end

  test "user with permission should be able to crud root locations" do
    flunk "test is not yet written"
  end

  test "sys admin should be able to crud non-root location" do
    flunk "test is not yet written"
  end

  test "user with permission should be able to crud non-root location" do
    flunk "test is not yet written"
  end

  test "sys admin should be able to crud root group" do
    flunk "test is not yet written"
  end

  test "user with permission should be able to crud root group" do
    flunk "test is not yet written"
  end

  test "sys admin should be able to crud group" do
    flunk "test is not yet written"
  end

  test "user with permission should be able to crud group" do
    flunk "test is not yet written"
  end

  test "sys admin should be able to crud user access" do
    flunk "test is not yet written"
  end

  test "user with permission should be able to crud user access" do
    flunk "test is not yet written"
  end

  test "sys admin should be able to see locations in group" do
    flunk "test is not yet written"
  end

  test "user with permission should be able to see locations in group" do
    flunk "test is not yet written"
  end

  test "sys admin should be able to see items in group" do
    flunk "test is not yet written"
  end

  test "user with permission should be able to see items in group" do
    flunk "test is not yet written"
  end

  test "user with should be able to see specific location" do
    flunk "test is not yet written"
  end

  test "is_sys_admin? should only be true for sys admin" do
    flunk "test is not yet written"
  end

  test "authenticated? should be correct" do
    flunk "test is not yet written"
  end

  test "user permissions should be set to correct permissions" do
    flunk "test is not yet written"
  end

  test "user access permissions should be set to correct permissions" do
    flunk "test is not yet written"
  end

  test "activate should activate user" do
    flunk "test is not yet written"
  end

  test "user activation email should be sent" do
    flunk "test is not yet written"
  end

  test "user permissions should be created" do
    flunk "test is not yet written"
  end
end
