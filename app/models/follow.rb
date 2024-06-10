# frozen_string_literal: true

# The Follow class represents a follow relationship between two users in the application.
class Follow < ApplicationRecord
  validates :following_user_id, :followed_user_id, presence: true
  validates :following_user_id, uniqueness: { scope: :followed_user_id, message: 'has already followed this user' }
  # Following belongs to following_user, class name User
  belongs_to :following_user, class_name: 'User'

  # Followed belongs to followed_user, class name User
  belongs_to :followed_user, class_name: 'User'
end
