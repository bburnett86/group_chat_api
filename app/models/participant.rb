class Participant < ApplicationRecord
	belongs_to :user
  belongs_to :participable, polymorphic: true

	validates :user_id, uniqueness: { scope: :participable_id }
	validates :user_id, :participable_id, presence: true

	ROLE_VALUES = { MEMBER: 'MEMBER', ADMIN: 'ADMIN', SUPERADMIN: 'SUPERADMIN' }.freeze
	enum role: ROLE_VALUES
	validates :role, inclusion: { in: ROLE_VALUES.values }

	STATUS_VALUES = { PENDING: 'PENDING', ACCEPTED: 'ACCEPTED', REJECTED: 'REJECTED', MAYBE: "MAYBE" }.freeze
	validates :status, inclusion: { in: STATUS_VALUES.values }
	enum status: STATUS_VALUES

	def superadmin?
			role == 'SUPERADMIN'
	end

	def admin?
			role == 'ADMIN'
	end
end
