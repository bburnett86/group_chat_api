# test/models/event_guest_test.rb
require 'test_helper'

class EventGuestTest < ActiveSupport::TestCase
  def setup
    @event_guest = event_guests(:one) # assuming you have a fixture named "one"
  end

  test 'valid event_guest' do
    assert @event_guest.valid?
  end

  test 'invalid without user_id' do
    @event_guest.user_id = nil
    assert_not @event_guest.valid?
  end

  test 'invalid without event_id' do
    @event_guest.event_id = nil
    assert_not @event_guest.valid?
  end

  test 'invalid without status' do
    @event_guest.status = nil
    assert_not @event_guest.valid?
  end


  test 'invalid without role' do
    @event_guest.role = nil
    assert_not @event_guest.valid?
  end

end