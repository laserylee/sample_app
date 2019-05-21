require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @inactive_user  = users(:malory)
    @active_user = users(:lana)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      if user.activated?
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: 'delete'
        end
      end
    end
    assert_difference 'User.count', -1  do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
    assert_difference 'User.count', 0  do
      delete user_path(@non_admin)
    end
  end 
  
  test "index unless account is activated" do
    @inactive_user.activated = false
    assert_not @inactive_user.activated
    log_in_as(@inactive_user)
    get users_path
    assert_redirected_to login_path
  end

  test "profile redirect to root unless is activated" do
    assert_not @inactive_user.activated
    log_in_as(@inactive_user)
    get user_path(@inactive_user)
    assert_redirected_to root_url
  end
end
