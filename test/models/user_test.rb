# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test 'valid user' do
    assert @user.valid?
  end

  test 'invalid without email' do
    @user.email = nil
    refute @user.valid?, 'user is valid without an email'
    assert_not_nil @user.errors[:email], 'no validation error for email present'
  end

  test 'invalid without username' do
    @user.username = nil
    refute @user.valid?, 'user is valid without a username'
    assert_not_nil @user.errors[:username], 'no validation error for username present'
  end

  test 'invalid username length' do
    @user.username = 'a' * 31
    refute @user.valid?, 'username is valid with more than 30 characters'
    assert_not_nil @user.errors[:username], 'no validation error for username length'
  end

  test 'invalid without role' do
    @user.role = nil
    refute @user.valid?, 'user is valid without a role'
    assert_not_nil @user.errors[:role], 'no validation error for role present'
  end

  test 'invalid without active' do
    @user.active = nil
    refute @user.valid?, 'user is valid without an active status'
    assert_not_nil @user.errors[:active], 'no validation error for active status present'
  end

  test 'has many followings' do
    assert_equal @user.followings.count, Follow.where(following_user_id: @user.id).count
  end

  test 'has many followers' do
    assert_equal @user.followers.count, Follow.where(followed_user_id: @user.id).count
  end

  test 'has many posts' do
    assert_equal @user.posts.count, Post.where(user_id: @user.id).count
  end

  test 'posts are destroyed when user is destroyed' do
    user = users(:one)
    assert_difference 'Post.count', -user.posts.count do
      user.destroy
    end
  end

  test 'has many blocks' do
    assert_equal @user.blocks.count, Block.where(user_id: @user.id).count
  end

  test 'has many blocked users' do
    assert_equal @user.blocked_users.count, Block.where(user_id: @user.id).count
  end

  test 'invalid without avatar_url' do
    @user.avatar_url = nil
    refute @user.valid?, 'user is valid without an avatar_url'
    assert_not_nil @user.errors[:avatar_url], 'no validation error for avatar_url present'
  end
  
  test 'invalid avatar_url format' do
    @user.avatar_url = 'invalid_url'
    refute @user.valid?, 'user is valid with invalid avatar_url'
    assert_not_nil @user.errors[:avatar_url], 'no validation error for avatar_url format'
  end
  
  test 'has many likes as liker' do
    assert_equal @user.likes_as_liker.count, Like.where(liker_id: @user.id).count
  end
  
  test 'has many likes as liked' do
    assert_equal @user.likes_as_liked.count, Like.where(liked_id: @user.id).count
  end
  
  test 'likes are destroyed when user is destroyed' do
    user = users(:one)
    assert_difference 'Like.count', -(user.likes_as_liker.count + user.likes_as_liked.count) do
      user.destroy
    end
  end
  
  test 'blocks are destroyed when user is destroyed' do
    user = users(:one)
    assert_difference 'Block.count', -user.blocks.count do
      user.destroy
    end
  end
  
  test 'blocks with user as blocked_user are destroyed when user is destroyed' do
    user = users(:two)
    assert_difference 'Block.count', -Block.where(blocked_user_id: user.id).count do
      user.destroy
    end
  end

  test 'has many comments' do
    assert_equal @user.comments.count, Comment.where(user_id: @user.id).count
  end
  
  test 'comments are destroyed when user is destroyed' do
    user = users(:one)
    assert_difference 'Comment.count', -user.comments.count do
      user.destroy
    end
  end

end
