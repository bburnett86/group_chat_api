# frozen_string_literal: true

class FollowsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one) # Assuming you have a fixture for users
    @following_user = users(:two) # Assuming you have a fixture for users
    @user.update_attribute(:active, true)
    @following_user.update_attribute(:active, false)
    @user.update_attribute(:role, 'ADMIN') # Make the user an admin
    sign_in @user
    @follow = follows(:one)
  end

  test 'should create follow' do
    post api_v1_follows_url, params: { followed_user_id: @following_user.id, following_user_id: @user.id }
    assert_response :success
  end

  test 'should destroy follow' do
    delete api_v1_follow_url(@follow), params: { follows_user_id: @following_user.id }
    assert_response :success
  end
end
