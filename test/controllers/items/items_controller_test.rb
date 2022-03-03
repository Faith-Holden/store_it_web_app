require 'test_helper'
class Items::ItemsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin_user = users(:U1)
    @admin_user.user_accesses << user_accesses(:UA1)
    @other_user = users(:U2)
    @first_item = items(:I1)
  end


   # --------------wrong user ------------
   test "Should redirect create if wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Item.count' do
      post items_path, params: {item: {name: "I5"}}
    end
    assert_not flash.empty?
    assert_redirected_to items_path
  end

  test "Should redirect new if wrong user" do
    log_in_as(@other_user)
    get new_item_path
    assert_not flash.empty?
    assert_redirected_to items_path
  end

  test "Should redirect destroy if wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Item.count' do
      delete item_path(@first_item)
    end
    assert_not flash.empty?
    assert_redirected_to items_path
  end

  test "Should redirect show if wrong user" do
    log_in_as(@other_user)
    get item_path(@first_item)
    assert_not flash.empty?
    assert_redirected_to items_path
  end

  test "Should redirect edit if wrong user" do
    log_in_as(@other_user)
    get edit_item_path(@first_item)
    assert_not flash.empty?
    assert_redirected_to items_path
  end

  test "Should redirect update if wrong user" do
    log_in_as(@other_user)
    patch item_path(@first_item), params: {item: {name: "I5"}}
    assert_not flash.empty?
    assert_redirected_to items_path
  end
  #--------------------------------------------------
  # ------------not logged in ----------
  test "should redirect create if not logged in" do
    assert_no_difference 'Item.count' do
      post items_path, params: {item: {name: "I5"}}
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect new if not logged in" do
    get new_item_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference 'Item.count' do
      delete item_path(@first_item)
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect show if not logged in" do
    get item_path(@first_item)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit if not logged in" do
    get edit_item_path(@first_item)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update if not logged in" do
    patch item_path(@first_item), params: {item: {name: "I5"}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index if not logged in" do
    get items_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  #--------------------------------------------------

  #-----------correct, logged in user----------------------
  test "new should get new items view" do
    log_in_as(@admin_user)
    get new_item_path
    assert_response :success
  end

  test "should create new item with correct info" do
    log_in_as(@admin_user)
    assert_difference 'Item.count', 1 do
      post items_path, params: {item: { name: "I5"}}
    end
    assert_redirected_to Item.find_by(name: "I5")
  end

  test "should not create new item with incorrect info" do
    log_in_as(@admin_user)
    assert_no_difference 'Item.count' do
      post items_path, params: {item: {name: "        "}}
    end
    assert_redirected_to new_item_path
  end

  test "edit should get edit_item view" do
    log_in_as(@admin_user)
    get edit_item_path(@first_item)
    assert_response :success
  end

  test "should update item with correct info" do
    log_in_as(@admin_user)
    assert @first_item.name == "I1"
    patch item_path(@first_item), params: {item: {name: "I5"}}
    @first_item.reload
    assert @first_item.name == "I5"
    assert_redirected_to @first_item
  end

  test "should not update item with incorrect info" do
    log_in_as(@admin_user)
    assert @first_item.name == "I1"
    patch item_path(@first_item), params: {item: {name: "    "}}
    @first_item.reload
    assert @first_item.name == "I1"
    assert_redirected_to edit_item_path(@first_item)
  end

  test "Should destroy item" do
    log_in_as(@admin_user)
    assert_difference 'Item.count', -1 do
      delete item_path(@first_item)
    end
    assert_redirected_to items_path
  end

  test "index should show groups" do
    log_in_as(@admin_user)
    get items_path
    assert_response :success
  end

  test "should show access group" do
    log_in_as(@admin_user)
    get item_path(@first_item)
    assert_response :success
  end
  #--------------------------------------------------
end