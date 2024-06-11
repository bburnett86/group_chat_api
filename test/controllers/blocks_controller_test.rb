# frozen_string_literal: true

class BlocksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one) # Assuming you have a fixture for users
    @blocked_user = users(:two) # Assuming you have a fixture for users
    @user.update_attribute(:active, true)
    @blocked_user.update_attribute(:active, false)
    @user.update_attribute(:role, 'ADMIN') # Make the user an admin
    sign_in @user
    @block = blocks(:one) # Assuming you have a fixture for blocks
  end

	test 'should get index' do
		get api_v1_user_blocks_url(@user)
		assert_response :success
	end

  test 'should create block' do
    post api_v1_user_blocks_url(@user), params: { block: { blocked_user_id: @blocked_user.id } }
    assert_response :success
  end

  test 'should destroy block' do
    delete api_v1_user_block_url(@user, @block)
    assert_response :success
  end
end