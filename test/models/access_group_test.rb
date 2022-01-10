require "test_helper"

class AccessGroupTest < ActiveSupport::TestCase
  def setup
    @access_group = AccessGroup.new(name: "Test Name")
  end

  test "should be valid" do
    assert @access_group.valid?
  end

  test "name should be present" do
    @access_group.name = "    "
    assert_not @access_group.valid?
  end

  test "name should not be too long" do
    @access_group.name = "a" * 51
    assert_not @access_group.valid?
  end



end
