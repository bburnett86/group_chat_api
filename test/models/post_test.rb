# frozen_string_literal: true

# test/models/post_test.rb
require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:one) # assuming you have a fixture named "one" in posts.yml
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

  test 'belongs to user' do
    assert_equal @post.user, User.find(@post.user_id)
  end
end
