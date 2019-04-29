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

end
