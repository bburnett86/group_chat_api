class Like < ApplicationRecord
  belongs_to :liker, class_name: 'User'
  belongs_to :liked, class_name: 'User'
  belongs_to :likeable, polymorphic: true

  validate :liker_and_liked_cannot_be_same

  private

  def liker_and_liked_cannot_be_same
    errors.add(:base, 'Liker and Liked cannot be the same user') if liker_id == liked_id
  end
end