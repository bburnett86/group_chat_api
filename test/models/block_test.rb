# frozen_string_literal: true

# test/models/block_test.rb
require 'test_helper'

class BlockTest < ActiveSupport::TestCase
  def setup
    @block_one = blocks(:one)
    @block_two = blocks(:two)
  end

  test 'valid block' do
    assert @block_one.valid?
    assert @block_two.valid?
  end

  test 'invalid without user' do
    @block_one.user = nil
    refute @block_one.valid?, 'block is valid without a user'
    assert_not_nil @block_one.errors[:user], 'no validation error for user present'

    @block_two.user = nil
    refute @block_two.valid?, 'block is valid without a user'
    assert_not_nil @block_two.errors[:user], 'no validation error for user present'
  end

  test 'invalid without blocked_user' do
    @block_one.blocked_user = nil
    refute @block_one.valid?, 'block is valid without a blocked_user'
    assert_not_nil @block_one.errors[:blocked_user], 'no validation error for blocked_user present'

    @block_two.blocked_user = nil
    refute @block_two.valid?, 'block is valid without a blocked_user'
    assert_not_nil @block_two.errors[:blocked_user], 'no validation error for blocked_user present'
  end
end