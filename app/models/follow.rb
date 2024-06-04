# frozen_string_literal: true

# The Follow class represents a follow relationship between two users in the application.
class Follow < ApplicationRecord
  self.primary_key = 'id'
  belongs_to :followed_user, class_name: 'User'
  belongs_to :following_user, class_name: 'User'
end
