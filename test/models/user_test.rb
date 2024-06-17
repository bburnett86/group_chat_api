# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users, :blocks, :follows, :posts, :likes, :comments, :event_guests
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

  test 'validates email format' do
    @user.email = 'invalid_email'
    refute @user.valid?, 'user is valid with invalid email'
    assert_not_nil @user.errors[:email], 'no validation error for email format'
  end

  test 'downcases email before save' do
    @user.email = 'TEST@EMAIL.COM'
    @user.save
    assert_equal 'test@email.com', @user.reload.email
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

  test 'validates role inclusion' do
    @user.role = 'admin'
    assert @user.valid?
  end

  test 'sets default role before save' do
    @user.role = nil
    @user.save
    assert_equal 'standard', @user.reload.role
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
    assert_difference 'Post.count', -@user.posts.count do
      @user.destroy
    end
  end

  test 'has many blocks' do
    assert_equal @user.blocks.count, Block.where(user_id: @user.id).count
  end

  test 'has many blocked users' do
    assert_equal @user.blocked_users.count, Block.where(user_id: @user.id).count
  end

  test 'has many blocked_by' do
    assert_equal @user.blocked_by.count, Block.where(blocked_user_id: @user.id).count
  end

  test 'has many blocked_by_users' do
    assert_equal @user.blocked_by_users.count, User.joins(:blocks).where(blocks: { blocked_user_id: @user.id }).count
  end

  test 'blocked_by are destroyed when user is destroyed' do
    Block.create!(user: users(:two), blocked_user: @user)
    assert_difference 'Block.count', -1 do
      @user.destroy
    end
  end

  test 'destroys blocks with blocked_user before destroy' do
    Block.create!(user: users(:two), blocked_user: @user)
    assert_difference 'Block.count', -1 do
      @user.destroy
    end
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
    assert_difference 'Like.count', -(@user.likes_as_liker.count + @user.likes_as_liked.count) do
      @user.destroy
    end
  end

  test 'blocks are destroyed when user is destroyed' do
    Block.create!(user: @user, blocked_user: users(:two))
    assert_difference 'Block.count', -1 do
      @user.destroy
    end
  end

  test 'blocks with user as blocked_user are destroyed when user is destroyed' do
    Block.create!(user: @user, blocked_user: users(:two))
    assert_difference 'Block.count', -1 do
      @user.destroy
    end
  end

  test 'has many comments' do
    assert_equal @user.comments.count, Comment.where(user_id: @user.id).count
  end
  
  test 'comments are destroyed when user is destroyed' do
    assert_difference 'Comment.count', -@user.comments.count do
      @user.destroy
    end
  end

  test 'has many event_guests' do
    assert_equal @user.event_guests.count, EventGuest.where(user_id: @user.id).count
  end

  test 'has many events' do
    assert_equal @user.events.count, Event.joins(:event_guests).where(event_guests: { user_id: @user.id }).count
  end

  test 'event_guests are destroyed when user is destroyed' do
    assert_difference 'EventGuest.count', -@user.event_guests.count do
      @user.destroy
    end
  end

end
