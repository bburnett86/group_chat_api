require "test_helper"

class ClubTest < ActiveSupport::TestCase
  setup do
    @club = clubs(:one)
    @accepted_member = participants(:five)
    @pending_member = participants(:four)
    @rejected_member = participants(:six)
    @admin = participants(:four)
    @superadmin = participants(:five)
    @member = participants(:six)
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
    assert_includes @club.members, @member
  end
end