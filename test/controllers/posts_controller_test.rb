# frozen_string_literal: true

class Api::V1::PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @post = posts(:one)
    @event = events(:one)
    sign_in @user
  end

  test 'should get index' do
    get api_v1_posts_url
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_not_nil json_response
    assert(json_response.all? { |post| post.key?('user') && post['user'].key?('username') })
  end

  test 'should show post' do
    get api_v1_post_url(@post)
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_not_nil json_response
    assert_equal @post.id, json_response['id']
    assert json_response.key?('user') && json_response['user'].key?('username')
  end

  test 'should create post' do
    assert_difference('Post.count') do
      post api_v1_posts_url, params: { post: { description: 'New Description', close_friends: false, postable_id: @event.id, postable_type: "Event"} }
    end
    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal 'New Description', json_response['description']
    assert_equal @event.id, json_response['postable_id']
    assert_equal 'Event', json_response['postable_type']
  end

  test 'should update post' do
    patch api_v1_post_url(@post), params: { post: { description: 'Updated Description', close_friends: true } }
    assert_response :success
    @post.reload
    assert_equal 'Updated Description', @post.description
    assert_equal true, @post.close_friends
  end

  test 'should destroy post' do
    assert_difference('Post.count', -1) do
      delete api_v1_post_url(@post)
    end
    assert_response :success
  end
end