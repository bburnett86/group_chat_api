class Event < ApplicationRecord
  has_many :event_guests, dependent: :destroy
  has_many :users, through: :event_guests

  validates :description, :start_time, :end_time, :title, presence: true
  validates :description, length: { minimum: 20 }
  validates :title, length: { minimum: 5 }
  validate :start_time_before_end_time
  validate :start_time_and_end_time_are_datetime

	def deactivate_if_past
    self.update(active: false) if self.end_time < Time.zone.now
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
