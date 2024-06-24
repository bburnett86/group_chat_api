require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:one)
    @pending_guest = participants(:one)
    @going_guest = participants(:two)
    @not_going_guest = participants(:three)
    @maybe_guest = participants(:seven)
    @host = participants(:one)
    @organizer = participants(:two)
  end

  test 'valid event' do
    assert @event.valid?
  end

  test 'invalid without title' do
    @event.title = nil
    refute @event.valid?, 'event is valid without a title'
    assert_not_nil @event.errors[:title], 'no validation error for title present'
  end

  test 'invalid if title length is less than 5' do
    @event.title = 'tiny'
    refute @event.valid?, 'event is valid with a short title'
    assert_not_nil @event.errors[:title], 'no validation error for title present'
  end

  test 'invalid without description' do
    @event.description = nil
    refute @event.valid?, 'event is valid without a description'
    assert_not_nil @event.errors[:description], 'no validation error for description present'
  end

  test 'invalid if description length is less than 20' do
    @event.description = 'short'
    refute @event.valid?, 'event is valid with a short description'
    assert_not_nil @event.errors[:description], 'no validation error for description present'
  end

  test 'invalid without start_time' do
    @event.start_time = nil
    refute @event.valid?, 'event is valid without a start_time'
    assert_not_nil @event.errors[:start_time], 'no validation error for start_time present'
  end

  test 'invalid without end_time' do
    @event.end_time = nil
    refute @event.valid?, 'event is valid without a end_time'
    assert_not_nil @event.errors[:end_time], 'no validation error for end_time present'
  end

  test 'start_time and end_time should be datetime' do
    @event.start_time = 'not a datetime'
    @event.end_time = 'not a datetime'
    refute @event.valid?, 'event is valid with non-datetime start_time and end_time'
    assert_not_nil @event.errors[:start_time], 'no validation error for start_time present'
    assert_not_nil @event.errors[:end_time], 'no validation error for end_time present'
  end

  test 'start_time should be before end_time' do
    @event.start_time = Time.now + 2.hours
    @event.end_time = Time.now + 1.hour
    refute @event.valid?, 'event is valid with start_time after end_time'
    assert_not_nil @event.errors[:start_time], 'no validation error for start_time present'
  end

  test 'deactivate_if_past should set active to false if end_time is in the past' do
    @event.end_time = Time.now - 1.hour
    @event.deactivate_if_past
    refute @event.active, 'event is still active after end_time has passed'
  end

  test 'pending_guests returns correct participants' do
    assert_includes @event.pending_guests, @pending_guest
  end

  test 'going_guests returns correct participants' do
    assert_includes @event.going_guests, @going_guest
  end

  test 'not_going_guests returns correct participants' do
    assert_includes @event.not_going_guests, @not_going_guest
  end

  test 'maybe_guests returns correct participants' do
    assert_includes @event.maybe_guests, @maybe_guest
  end

  test 'guests returns correct participants' do
    assert @event.guests.include?(@not_going_guest), 'Guests does not include not going guest'
    assert @event.guests.include?(@maybe_guest), 'Guests does not include maybe guest'
  end

  test 'hosts returns correct participants' do
    assert_includes @event.hosts, @host
  end

  test 'organizers returns correct participants' do
    assert_includes @event.organizers, @organizer
  end
end