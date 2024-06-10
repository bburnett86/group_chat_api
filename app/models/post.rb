class Post < ApplicationRecord
	validates :description, :user_id, presence: true
  belongs_to :user
end 