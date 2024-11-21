# frozen_string_literal: true

class Post < ApplicationRecord
  validates :description, :user_id, presence: true
  belongs_to :user
  belongs_to :postable, polymorphic: true, optional: true
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy
end
