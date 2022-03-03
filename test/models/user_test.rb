require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "User Name", email: "test@email.com", password: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 201
    assert_not @user.valid?
  end

  test "email should be valid" do
    flunk "test is not yet written"
  end

  test "sys admin should see all items" do
    flunk "test is not yet written"
  end

  test "non-admin should see only restricted items" do
    flunk "test is not yet written"
  end

  test "crudable_descendants gets all sublocations that a user can crud" do
    flunk "test is not yet written"
  end

  test "visible_ancestor_locations gets all location ancestors user can see" do
    flunk "test is not yet written"
  end

  test "visible_access_groups should get all groups user has view access in" do
    flunk "test is not yet written"
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
