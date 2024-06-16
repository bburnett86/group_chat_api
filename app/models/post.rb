# frozen_string_literal: true

class Post < ApplicationRecord
  enum post_type: { wall: 'WALL', status: 'STATUS', event: 'EVENT', club: 'CLUB' }

  validates :description, :user_id, presence: true
  validates :post_type, inclusion: { in: post_types.keys, message: "%{value} is not a valid type" }
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy
end
