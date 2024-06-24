class Club < ApplicationRecord
	validates :name, :about_us, presence: true
	validates :name, length: { minimum: 5 }
	validates :name, uniqueness: true
	validates :about_us, length: { minimum: 20 } 

  has_many :participants, as: :participable, dependent: :destroy
  has_many :members, through: :participants

	def accepted_members
		participants.where(status: Participant.statuses[:ACCEPTED])
	end

	def pending_members
			participants.where(status: Participant.statuses[:PENDING])
	end

	def rejected_members
			participants.where(status: Participant.statuses[:REJECTED])
	end

	def admins
			participants.where(role: Participant.roles[:ADMIN])
	end

	def superadmins
			participants.where(role: Participant.roles[:SUPERADMIN])
	end

	def members
			participants.where(role: Participant.roles[:MEMBER])
	end
end
