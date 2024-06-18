class ClubMember < ApplicationRecord
	belongs_to :user
	belongs_to :club

	validates :user_id, uniqueness: { scope: :club_id }
	validates :user_id, :club_id, presence: true

	ROLE_VALUES = { MEMBER: 'MEMBER', ADMIN: 'ADMIN', SUPERADMIN: 'SUPERADMIN' }.freeze

	enum role: ROLE_VALUES

	validates :role, inclusion: { in: ROLE_VALUES.values }

	STATUS_VALUES = { PENDING: 'PENDING', ACCEPTED: 'ACCEPTED', REJECTED: 'REJECTED' }.freeze

	enum status: STATUS_VALUES

	validates :status, inclusion: { in: STATUS_VALUES.values }

	def superadmin?
			role == 'SUPERADMIN'
	end

	def admin?
			role == 'ADMIN'
	end
end