require "test_helper"

class AccountActivationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:unactivated)
  end

  test "should activate unactivated user if good activation link" do
    flunk "need to finish this test"
    # assert_not @user.activated?
    # get edit_account_activation_path(@user.activation_token, email: @user.email, id: @user.id)
    # @user.reload
    # assert @user.activated?
    # assert @user.is_logged_in?
    # assert_not flash.empty?
    # assert_redirected_to @user
  end

  test "should redirect if bad activation link " do
    flunk "need to finish this test"
    # assert_not @user.activated?
    # get edit_account_activation_path("bad token", email: @user.email, id: @user.id)
    # @user.reload
    # assert_not @user.activated?
    # assert_not @user.is_logged_in?
    # assert_not flash.empty?
    # assert_redirected_to root_url
  end
end
