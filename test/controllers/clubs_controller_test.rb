require "test_helper"

class ClubsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @club = clubs(:one)
    @user = users(:five)
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
end