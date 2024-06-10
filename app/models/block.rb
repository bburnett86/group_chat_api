class Block < ApplicationRecord
	validates :user_id, :blocked_user_id, presence: true

  belongs_to :user
  belongs_to :blocked_user, class_name: 'User'
end