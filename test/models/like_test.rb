require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @like = likes(:one)
  end

  test 'should be valid' do
    assert @like.valid?
  end

  test 'should require a liker_id' do
    @like.liker_id = nil
    assert_not @like.valid?
  end

  test 'should require a liked_id' do
    @like.liked_id = nil
    assert_not @like.valid?
  end

  test 'should require a likeable_id' do
    @like.likeable_id = nil
    assert_not @like.valid?
  end

  test 'should require a likeable_type' do
    @like.likeable_type = nil
    assert_not @like.valid?
  end

  test 'liker_id and liked_id should not be identical' do
    @like.liked_id = @like.liker_id
    assert_not @like.valid?
    assert_includes @like.errors.full_messages, 'Liker and Liked cannot be the same user'
  end
end