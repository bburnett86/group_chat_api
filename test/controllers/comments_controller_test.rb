require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @comment = comments(:one)
    @user = users(:one)
    @user.update!(active: true, role: :superadmin, bio: 'user_1_bio')
    @post = posts(:one)
    sign_in @user
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post api_v1_post_comments_url(@post), params: { comment: { description: 'New comment' } }, as: :json
    end
  
    assert_response :created
  end

  test "should update comment" do
    patch api_v1_post_comment_url(@post, @comment), params: { comment: { description: 'Updated comment' } }, as: :json
    assert_response :success
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete api_v1_post_comment_url(@post, @comment), as: :json
    end

    assert_response :no_content
  end
end