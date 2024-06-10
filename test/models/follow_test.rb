# frozen_string_literal: true

# test/models/follow_test.rb
require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  def setup
    @follow = follows(:one) # assuming you have a fixture named "one" in follows.yml
  end

  test 'valid follow' do
    assert @follow.valid?
  end

  test 'invalid without following_user_id' do
    @follow.following_user_id = nil
    refute @follow.valid?, 'follow is valid without a following_user_id'
    assert_not_nil @follow.errors[:following_user_id], 'no validation error for following_user_id present'
  end

  test 'invalid without followed_user_id' do
    @follow.followed_user_id = nil
    refute @follow.valid?, 'follow is valid without a followed_user_id'
    assert_not_nil @follow.errors[:followed_user_id], 'no validation error for followed_user_id present'
  end

  test 'invalid with duplicate following_user_id and followed_user_id' do
    duplicate_follow = @follow.dup
    @follow.save
    refute duplicate_follow.valid?, 'follow is valid with a duplicate following_user_id and followed_user_id'
    assert_not_nil duplicate_follow.errors[:following_user_id],
                   'no validation error for duplicate following_user_id and followed_user_id'
  end

  test 'belongs to following_user' do
    assert_equal @follow.following_user, User.find(@follow.following_user_id)
  end

  test 'belongs to followed_user' do
    assert_equal @follow.followed_user, User.find(@follow.followed_user_id)
  end
end
