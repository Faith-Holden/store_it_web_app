require 'test_helper'
class Users::UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin_user = users(:U1)
    @admin_user.user_accesses << user_accesses(:UA1)
    @other_user = users(:U2)
    @first_new_user = users(:U3)
    @second_new_user = users(:U4)
    @access_group = access_groups(:AG1)
  end


  # --------------wrong user ------------
  test "should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      post users_path, params: {access_group: {name: "U5"}}
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "Should redirect new if wrong user" do
    log_in_as(@other_user)
    get new_user_path
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "Should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@admin_user)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "Should redirect show if wrong user" do
    log_in_as(@other_user)
    get user_path(@admin_user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect edit if wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@admin_user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update if wrong user" do
    log_in_as(@other_user)
    patch user_path(@admin_user), params: {user: {name: "U5"}}
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  #--------------------------------------------------

  # ------------not logged in ----------
  test "should redirect destroy if not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect show if not logged in" do
    get access_group_path(@other_user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit if not logged in" do
    get edit_user_path(@other_user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update if not logged in" do
    patch user_path(@other_user), params: {user: {name: "U5"}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get users_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------
  #-----------correct, logged in user----------------------
  test "new should get new users view" do
    get new_user_path
    assert_response :success
  end

  test "should create new user with correct info" do
    assert_difference 'User.count', 1 do
      post users_path, params: {user: {name: "U5", email: "testnewemail@example.com", password: "password"}}
    end
    assert_template :new
  end

  test "should not create new user with incorrect info" do
    assert_no_difference 'User.count' do
      post users_path, params: {user: {name: "   ", email: "testnewemail@example.com", password: "password"}}
    end
    assert_redirected_to new_user_path
  end

  test "edit should get edit_users view" do
    log_in_as(@admin_user)
    get edit_user_path(@admin_user)
    assert_response :success
  end

  test "should update user with correct info" do
    log_in_as(@admin_user)
    assert @other_user.name == "U2"
    patch user_path(@other_user), params: {user: {name: "U5"}}
    @other_user.reload
    assert @other_user.name == "U5"
    assert_redirected_to @other_user
  end

  test "should not update user with incorrect info" do
    log_in_as(@admin_user)
    assert @other_user.name == "U2"
    patch user_path(@other_user), params: {user: {name: "    "}}
    assert @other_user.name == "U2"
    assert_redirected_to edit_user_path(@other_user)
  end

  test "should destroy user" do
    log_in_as(@admin_user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to users_path
  end

  test "index should show users" do
    log_in_as(@admin_user)
    get users_path
    assert_response :success
  end

  test "should show user" do
    log_in_as(@admin_user)
    get access_group_path(@other_user)
    assert_response :success
  end
   #--------------------------------------------------
end