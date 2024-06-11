class Block < ApplicationRecord
	validates :user_id, :blocked_user_id, presence: true
	validates :blocked_user_id, uniqueness: { scope: :user_id, message: 'has already blocked this user' }

  belongs_to :user
  belongs_to :blocked_user, class_name: 'User'
end