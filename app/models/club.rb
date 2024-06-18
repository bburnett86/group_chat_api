class Club < ApplicationRecord
	validates :name, :about_us, presence: true
	validates :name, length: { minimum: 5 }
	validates :name, uniqueness: true
	validates :about_us, length: { minimum: 20 } 

	has_many :club_members, dependent: :destroy
	has_many :users, through: :club_members

	def accepted_members
		club_members.where(status: ClubMember.statuses[:ACCEPTED])
	end

	def pending_members
			club_members.where(status: ClubMember.statuses[:PENDING])
	end

	def rejected_members
			club_members.where(status: ClubMember.statuses[:REJECTED])
	end

	def admins
			club_members.where(role: ClubMember.roles[:ADMIN])
	end

	def superadmins
			club_members.where(role: ClubMember.roles[:SUPERADMIN])
	end

	def members
			club_members.where(role: ClubMember.roles[:MEMBER])
	end
end
