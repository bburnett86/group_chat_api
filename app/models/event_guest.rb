class EventGuest < ApplicationRecord
	validates :user_id, :event_id, :status, :role, presence: true

  STATUS_VALUES = { PENDING: 'PENDING', GOING: 'GOING', NOT_GOING: 'NOT_GOING', MAYBE: 'MAYBE' }.freeze
  ROLE_VALUES = { GUEST: 'GUEST', HOST: 'HOST', ORGANIZER: 'ORGANIZER' }.freeze

  enum status: STATUS_VALUES
  enum role: ROLE_VALUES

  validates :status, inclusion: { in: STATUS_VALUES.values }
  validates :role, inclusion: { in: ROLE_VALUES.values }

	belongs_to :user
  belongs_to :event
end
