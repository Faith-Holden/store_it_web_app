require 'test_helper'
class Locations::AccessGroupsControllerTest < ActionDispatch::IntegrationTest
   # ----tests for redirecting if wrong user ------------
   test "Should redirect create if wrong user" do
    flunk "test is not yet written"
  end

  test "Should redirect new if wrong user" do
    flunk "test is not yet written"
  end

  test "Should redirect destroy if wrong user" do
    flunk "test is not yet written"
  end

  test "Should redirect index if wrong user" do
    flunk "test is not yet written"
  end
  #--------------------------------------------------

  # --tests for redirecting if not logged in ----------
  test "Should redirect create if not signed in" do
    flunk "test is not yet written"
  end

  test "Should redirect new if not signed in" do
    flunk "test is not yet written"
  end

  test "Should redirect destroy if not signed in" do
    flunk "test is not yet written"
  end

  test "Should redirect index if not signed in" do
    flunk "test is not yet written"
  end
  #--------------------------------------------------


  #-----------should do actions----------------------
  test "new should render new access_group_locations view" do
    flunk "test is not yet written"
  end

  test "Should create new location_access with correct info" do
    flunk "test is not yet written"
  end

  test "should not create new location_access with incorrect info" do
    flunk "test is not yet written"
  end

  test "Should destroy location_access" do
    flunk "test is not yet written"
  end

  test "index should show location_access" do
    flunk "test is not yet written"
  end
end