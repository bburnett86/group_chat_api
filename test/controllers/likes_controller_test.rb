# frozen_string_literal: true

class Api::V1::LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one) # assuming you have a posts fixture
    @like = likes(:one) # assuming you have a likes fixture
  end

  test 'should return likes for post' do
    get api_v1_post_likes_url(@post)
    assert_response :success
  end

  test 'should create like for post' do
    assert_difference('Like.count') do
      post api_v1_post_likes_url(@post), params: { like: { liked_id: users(:two).id, liker_id: users(:one).id } }
    end

    assert_response :created
  end

  test 'should not create like if liker and liked are the same user' do
    assert_no_difference('Like.count') do
      post api_v1_post_likes_url(@post), params: { like: { liked_id: users(:one).id, liker_id: users(:one).id } }
    end

    assert_response :unprocessable_entity
  end

  test 'should destroy like on post' do
    assert_difference('Like.count', -1) do
      delete api_v1_post_like_url(@post, @like)
    end

    assert_response :no_content
  end
end