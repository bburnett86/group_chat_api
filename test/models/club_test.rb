require "test_helper"

class ClubTest < ActiveSupport::TestCase
  setup do
    @club = clubs(:one) # assuming you have a clubs fixture
    @accepted_member = club_members(:accepted) # assuming you have a club_members fixture
    @pending_member = club_members(:pending)
    @rejected_member = club_members(:rejected)
    @admin = club_members(:admin)
    @superadmin = club_members(:superadmin)
  end

  test "accepted_members method" do
    assert_includes @club.accepted_members, @accepted_member
  end

  test "pending_members method" do
    assert_includes @club.pending_members, @pending_member
  end

  test "rejected_members method" do
    assert_includes @club.rejected_members, @rejected_member
  end

  test "admins method" do
    assert_includes @club.admins, @admin
  end

  test "superadmins method" do
    assert_includes @club.superadmins, @superadmin
  end

  test "members method" do
    assert_includes @club.members, @accepted_member
  end
end