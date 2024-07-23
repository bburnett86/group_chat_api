require "test_helper"

class Api::V1::EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @event = events(:one)
    @user = users(:one)
    @user.update!(role: 'superadmin')
    sign_in @user
    @user_two = users(:two)
    @user_three = users(:three)
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

  test "should bulk invite guests" do
    guest_users = { guests: [ { user_id: users(:five).id, event_id: events(:one).id }] }
    assert_difference('@event.participants.count', 1) do 
      post invite_guests_api_v1_event_bulk_index_url(@event), params: guest_users
    end
    assert_response :success
    assert_not_nil response
    json_response = JSON.parse(response.body)
    assert_equal "1 Guest invited successfully", json_response["message"]
  end

  test 'should update multiple user roles' do
    users = [
      { user_id: @user_three.id, role: 'ADMIN', event_id: events(:one).id },
      { user_id: @user_two.id, role: 'ADMIN', event_id: events(:one).id }
    ]
    patch role_updates_api_v1_event_bulk_index_url(@event), params: { users: users }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 'Roles updated successfully', json_response["message"]
  end
  
end