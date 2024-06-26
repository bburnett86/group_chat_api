require "test_helper"

class ClubsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @club = clubs(:one)
    @user = users(:five)
    @user_two = users(:two)
    @user_three = users(:three)
    sign_in @user
  end

  test "should get index" do
    get api_v1_clubs_url, as: :json
    assert_response :success
  end

  test "should create club" do
    assert_difference('Club.count') do
      post api_v1_clubs_url, params: { club: { name: 'New Club', about_us: 'This is a new club with this club about us.', public: false } }, as: :json
    end

    assert_response :success
  end

  test "should show club" do
    get api_v1_club_url(@club), as: :json
    assert_response :success
  end

  test "should update club" do
    @user.update!(role: :admin)
    patch api_v1_club_url(@club), params: { club: { name: 'Updated Club', about_us: 'This is an updated club with this club about us.', public: false } }, as: :json
    assert_response :success
  end

  test "should destroy club" do
    @user.update!(role: :superadmin)
    assert_difference('Club.count', -1) do
      delete api_v1_club_url(@club), as: :json
    end

    assert_response 204
  end

  test "should get accepted_members" do
    get accepted_members_api_v1_club_url(@club), as: :json
    assert_response :success
  end

  test "should get pending_members" do
    get pending_members_api_v1_club_url(@club), as: :json
    assert_response :success
  end

  test "should get rejected_members" do
    get rejected_members_api_v1_club_url(@club), as: :json
    assert_response :success
  end

  test "should get admins" do
    get admins_api_v1_club_url(@club), as: :json
    assert_response :success
  end

  test "should get superadmins" do
    get superadmins_api_v1_club_url(@club), as: :json
    assert_response :success
  end

  test "should get members" do
    get members_api_v1_club_url(@club), as: :json
    assert_response :success
  end
  test "should bulk invite members" do
    invites = { members: [{ user_id: users(:two).id, club_id: @club.id }] }
    assert_difference('@club.participants.count', 1) do 
      post bulk_invite_members_api_v1_clubs_url, params: invites
    end
    assert_response :success
    assert_not_nil response
    json_response = JSON.parse(response.body)
    assert_equal "1 Member invited successfully", json_response["message"]  
  end

  test 'should update multiple user roles' do
    users = [
      { user_id: @user_three.id, role: 'ADMIN', club_id: @club.id },
      { user_id: @user_two.id, role: 'ADMIN', club_id: @club.id }
    ]
    patch bulk_role_updates_api_v1_clubs_url, params: { users: users }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 'Roles updated successfully', json_response["message"]
  end
end