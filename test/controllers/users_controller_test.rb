# frozen_string_literal: true

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one) # Assuming you have a fixture for users
    @following_user = users(:two) # Assuming you have a fixture for users
    @user.update!(active: true, role: :superadmin, bio: 'user_1_bio') # Make the user an admin
    @following_user.update!(active: false, role: :standard, bio: 'user_2_bio')
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
    patch api_v1_user_url(@user), params: { user: { bio: 'New Bio', show_email: true } }
    assert_response :success
    @user.reload
    assert_equal 'New Bio', @user.bio
    assert_equal true, @user.show_email
  end

  test 'should activate user' do
    @following_user.update_attribute(:active, false)
    patch activate_api_v1_user_url(@following_user)
    @following_user.reload
    assert_response :success
    assert_equal true, @following_user.active
  end

  test 'should not activate already active user' do
    patch activate_api_v1_user_url(@user)
    assert_response :bad_request
  end

  test 'should deactivate user' do
    @following_user.update_attribute(:active, true)
    patch deactivate_api_v1_user_url(@following_user)
    @following_user.reload
    assert_response :success
    assert_equal false, @following_user.active
  end

  test 'should not deactivate already inactive user' do
    patch deactivate_api_v1_user_url(@following_user)
    assert_response :bad_request
  end

  test 'should update user as admin' do
    patch admin_user_update_api_v1_user_url(@user),
          params: { user: { username: 'New Username', role: :admin, active: true, show_email: true, bio: 'New Bio' } }
    assert_response :success
    @user.reload
    assert_equal 'New Username', @user.username
    assert_equal 'admin', @user.role
    assert_equal true, @user.active
    assert_equal true, @user.show_email
    assert_equal 'New Bio', @user.bio
  end

  test 'should update multiple user roles' do
    user_role_pairs = [
      { user_id: @user.id, role: :admin },
      { user_id: @following_user.id, role: :admin }
    ]
    patch admin_update_role_bulk_api_v1_users_url, params: { user_role_pairs: user_role_pairs }
    assert_response :success
    @user.reload
    @following_user.reload
    assert_equal 'admin', @user.role
    assert_equal 'admin', @following_user.role
  end
end
