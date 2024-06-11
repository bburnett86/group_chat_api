# frozen_string_literal: true

class BlocksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @blocked_user = users(:two)
    @user.update_attribute(:active, true)
    @blocked_user.update_attribute(:active, false)
    @user.update_attribute(:role, 'ADMIN') 
    sign_in @user
    @block = blocks(:one)
		@unblocked_user = users(:three)
  end

	test 'should get index' do
		get api_v1_user_blocks_url(@user)
		assert_response :success
	end

  test 'should not create block if user is already blocked' do
    post api_v1_user_blocks_url(@user), params: { block: { blocked_user_id: @blocked_user.id } }
    assert_response :unprocessable_entity
  end

	test 'should create block' do
		post api_v1_user_blocks_url(@user), params: { block: { blocked_user_id: @unblocked_user.id } }
		assert_response :success
	end

  test 'should destroy block' do
    delete api_v1_user_block_url(@user, @block)
    assert_response :success
  end
end