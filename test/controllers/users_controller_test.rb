# frozen_string_literal: true

# UsersControllerTest is a test case that tests the actions of UsersController.
# It includes tests for the index, show, update, destroy, followers_count, and following_count actions.
class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one) # Assuming you have a fixture for users
    @following_user = users(:two) # Assuming you have a fixture for users
    @user.update_attribute(:active, true)
    @following_user.update_attribute(:active, false)
    @user.update_attribute(:role, 'ADMIN') # Make the user an admin
    sign_in @user
  end
  test 'should get index' do
    get api_v1_users_url
    assert_response :success
  end

  test 'should show user' do
    get api_v1_user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    patch api_v1_user_url(@user), params: { user: { username: 'New Name' } }
    assert_response :success
  end

  test 'should activate user' do
  	patch activate_api_v1_user_url(@user)
    @user.reload
    assert_response :success
  	assert_equal true, User.find(@user.id).active
  end

  test 'should deactivate user' do
  	patch deactivate_api_v1_user_url(@following_user)
    @following_user.reload
    assert_response :success
  	assert_equal false, User.find(@following_user.id).active
  end

  test 'should get followers count' do
    get api_v1_user_followers_count_url(@user)
    assert_response :success
  end

  test 'should get following count' do
    get api_v1_user_following_count_url(@user)
    assert_response :success
  end

  test 'should get following' do
    get api_v1_user_following_url(@following_user)
    assert_response :success
    assert_includes @response.body, @user.id.to_s
  end

  test 'should get followers' do
    get api_v1_user_followers_url(@user)
    assert_response :success
    assert_includes @response.body, @following_user.id.to_s
  end
end
