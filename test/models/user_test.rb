require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.create(name:"Example Aser",
                        email:"example_aser@gmail.com",
                        password:"foobar",
                        password_confirmation:"foobar")
  end

  test "should get valid" do
    assert @user.valid?
  end

  test "name should be present" do
    assert_not @user.update_attributes(name:"       ")
    assert_not @user.valid?
  end

  test "user should be unique" do
    @user2 = User.create(name:"Example Aser",
                         email:"example_aser@gmail.com",
                         password:"foobar",
                         password_confirmation:"foobar")
    assert_not  @user2.valid?
  end

  test "case insensitive" do
    @user3 = User.create(name:"example aser",
                         email:"Example_Aser@gmail.com",
                         password:"foobar",
                         password_confirmation:"foobar")
    assert_not @user3.valid?
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end

end
