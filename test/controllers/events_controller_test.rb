require "test_helper"

class Api::V1::EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @event = events(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get api_v1_events_url
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post api_v1_events_url, params: { event: { title: 'New Event With a Longer Title', description: 'Event Description That Is Longer Too', start_time: Time.now, end_time: Time.now + 1.hour, active: true } }
    end
    assert_response :created
  end

  test "should show event" do
    get api_v1_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    patch api_v1_event_url(@event), params: { event: { title: 'Updated Event' } }
    assert_response :success
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete api_v1_event_url(@event)
    end
    assert_response :success
  end
end