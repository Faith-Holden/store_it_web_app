require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_item_url
    assert_response :success
  end
end
