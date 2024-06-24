class Event < ApplicationRecord
has_many :participants, as: :participable, dependent: :destroy
has_many :guests, through: :participants

validates :description, :start_time, :end_time, :title, presence: true
validates :description, length: { minimum: 20 }
validates :title, length: { minimum: 5 }
validate :start_time_before_end_time
validate :start_time_and_end_time_are_datetime

def deactivate_if_past
  self.update(active: false) if self.end_time < Time.zone.now
end

def pending_guests
  participants.where(status: Participant.statuses[:PENDING])
end

def going_guests
  participants.where(status: Participant.statuses[:ACCEPTED])
end

def not_going_guests
  participants.where(status: Participant.statuses[:REJECTED])
end

def maybe_guests
  participants.where(status: Participant.statuses[:MAYBE])
end

def guests
  participants.where(role: Participant.roles[:MEMBER])
end

def hosts
  participants.where(role: Participant.roles[:ADMIN])
end

def organizers
  participants.where(role: Participant.roles[:SUPERADMIN])
end

private

def start_time_before_end_time
  if (start_time && end_time) && (start_time >= end_time)
    errors.add(:start_time, "must be before end time")
  end
end

def start_time_and_end_time_are_datetime
  [:start_time, :end_time].each do |time|
    errors.add(time, "must be a datetime") unless send(time).is_a?(ActiveSupport::TimeWithZone)
  end
end
end
