require "test_helper"

class AccessGroupsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_access_group_url
    assert_response :success
  end
end
