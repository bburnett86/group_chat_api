require "test_helper"

class Api::V1::EventGuestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @event = events(:one) # assuming you have a fixture for events
    @user = users(:one)
    @event_guest = event_guests(:one)
    sign_in @user
  end

  test "should get index" do
    get api_v1_event_event_guests_url(@event)
    assert_response :success
  end

  test "should create event_guest" do
    assert_difference('EventGuest.count') do
      post api_v1_event_event_guests_url(@event), params: { event_guest: { user_id: users(:four).id, event_id: @event.id, status: @event_guest.status, role: @event_guest.role } }
    end
    assert_response :created
  end

  test "should destroy event_guest" do
    assert_difference('EventGuest.count', -1) do
      delete api_v1_event_event_guest_url(@event, @event_guest)
    end
    assert_response :success
  end

  test "should add multiple guests" do
    patch add_multiple_guests_api_v1_event_event_guests_url(@event), params: { guest_id_array: [users(:four).id, users(:three).id] } 
    assert_response :success
  end

  test "should update multiple guest roles" do
    patch update_multiple_guest_roles_api_v1_event_event_guests_url(@event), params: { guest_role_pairs: [{ user_id: users(:two).id, role: 'HOST' }, { user_id: @user.id, role: 'ORGANIZER' }] } 
    assert_response :success
  end
end