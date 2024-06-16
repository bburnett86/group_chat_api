# frozen_string_literal: true

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = comments(:one)
  end

  test 'valid comment' do
    assert @comment.valid?
  end

  test 'invalid without description' do
    @comment.description = nil
    refute @comment.valid?, 'comment is valid without a description'
    assert_not_nil @comment.errors[:description], 'no validation error for description present'
  end

  test 'invalid without post' do
    @comment.post = nil
    refute @comment.valid?, 'comment is valid without a post'
    assert_not_nil @comment.errors[:post], 'no validation error for post present'
  end

  test 'invalid without user' do
    @comment.user = nil
    refute @comment.valid?, 'comment is valid without a user'
    assert_not_nil @comment.errors[:user], 'no validation error for user present'
  end

  test 'belongs to post' do
    assert_equal @comment.post, Post.find(@comment.post_id)
  end

  test 'belongs to user' do
    assert_equal @comment.user, User.find(@comment.user_id)
  end

  test 'has many likes' do
    assert_equal @comment.likes.count, Like.where(likeable: @comment).count
  end

  test 'likes are destroyed when comment is destroyed' do
    comment = comments(:one)
    assert_difference 'Like.count', -comment.likes.count do
      comment.destroy
    end
  end
end