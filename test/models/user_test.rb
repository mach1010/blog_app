require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new( name: "Example User", email: "user@example.com", 
                      password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = ''
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = ''
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = 'a' * 256
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do|valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test "email addresses should be downcased" do
    @user.email = @user.email.upcase
    @user.save
    assert_equal @user.reload.email, @user.email.downcase
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem Ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    mach1010 = users(:mach1010)
    archer  = users(:archer)
    assert_not mach1010.following?(archer)
    mach1010.follow(archer)
    assert mach1010.following?(archer)
    assert archer.followers.include?(mach1010)
    mach1010.unfollow(archer)
    assert_not mach1010.following?(archer)
  end
  
  test "feed should have the right posts" do
    mach1010 = users(:mach1010)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert mach1010.feed.include?(post_following)
    end
    # Posts from self
    mach1010.microposts.each do |post_self|
      assert mach1010.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not mach1010.feed.include?(post_unfollowed)
    end
  end
end