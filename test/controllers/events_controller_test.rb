require "test_helper"

class Api::V1::EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @event = events(:one)
    @user = users(:one)
    @user.update!(role: 'superadmin')
    @user_two = users(:two)
    @user_three = users(:three)
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

  test "should get pending guests" do
    get pending_guests_api_v1_event_url(@event)
    assert_response :success
    assert_equal @event.pending_guests.as_json, JSON.parse(response.body)
  end
  
  test "should get going guests" do
    get going_guests_api_v1_event_url(@event)
    assert_response :success
    assert_equal @event.going_guests.as_json, JSON.parse(response.body)
  end
  
  test "should get not going guests" do
    get not_going_guests_api_v1_event_url(@event)
    assert_response :success
    assert_equal @event.not_going_guests.as_json, JSON.parse(response.body)
  end
  
  test "should get maybe guests" do
    get maybe_guests_api_v1_event_url(@event)
    assert_response :success
    assert_equal @event.maybe_guests.as_json, JSON.parse(response.body)
  end
  
  
  test "should get hosts" do
    get hosts_api_v1_event_url(@event)
    assert_response :success
    assert_equal @event.hosts.as_json, JSON.parse(response.body)
  end
  
  test "should get organizers" do
    get organizers_api_v1_event_url(@event)
    assert_response :success
    assert_equal @event.organizers.as_json, JSON.parse(response.body)
  end

  test "should bulk invite guests" do
    guest_users = { guests: [ { user_id: users(:five).id, event_id: events(:one).id }] }
    assert_difference('@event.participants.count', 1) do 
      post bulk_invite_guests_api_v1_events_url, params: guest_users
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
    patch bulk_role_updates_api_v1_events_url, params: { users: users }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 'Roles updated successfully', json_response["message"]
  end
  
end