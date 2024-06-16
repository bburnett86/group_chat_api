# frozen_string_literal: true

# test/models/post_test.rb
require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:one)
    @post.update(description: 'New Description')
  end

  test 'valid post' do
    assert @post.valid?
  end

  test 'invalid without description' do
    @post.description = nil
    refute @post.valid?, 'post is valid without a description'
    assert_not_nil @post.errors[:description], 'no validation error for description present'
  end

  test 'invalid without user_id' do
    @post.user_id = nil
    refute @post.valid?, 'post is valid without a user_id'
    assert_not_nil @post.errors[:user_id], 'no validation error for user_id present'
  end

  test 'invalid without type' do
    @post.post_type = nil
    refute @post.valid?, 'post is valid without a type'
    assert_not_nil @post.errors[:post_type], 'no validation error for type present'
  end

  test 'belongs to user' do
    assert_equal @post.user, User.find(@post.user_id)
  end
  
  test 'has many likes' do
    assert_equal @post.likes.count, Like.where(likeable: @post).count
  end
  
  test 'likes are destroyed when post is destroyed' do
    post = posts(:one)
    assert_difference 'Like.count', -post.likes.count do
      post.destroy
    end
  end

  test 'has many comments' do
    assert_equal @post.comments.count, Comment.where(post_id: @post.id).count
  end
  
  test 'comments are destroyed when post is destroyed' do
    post = posts(:one)
    assert_difference 'Comment.count', -post.comments.count do
      post.destroy
    end
  end
end
