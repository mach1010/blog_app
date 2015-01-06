require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:mach1010)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "content should be present" do
    assert_not @micropost.content.empty?
  end
  
  test "content should be no more than 140 chars" do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end
  
  test "order should be most recent first" do
    assert_equal Micropost.first, microposts(:most_recent)
  end
  
end