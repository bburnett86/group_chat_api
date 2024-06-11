# frozen_string_literal: true

# The User class represents a user in the application. It contains methods for
# validating user data, handling password encryption, and managing user roles.
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true, length: { in: 5..30 }
  validates :avatar_url, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates :active, inclusion: { in: [true, false] }

  before_save :downcase_email
  before_destroy :destroy_blocks_with_blocked_user


  enum role: { standard: 'STANDARD', admin: 'ADMIN', superadmin: 'SUPERADMIN' }

  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  # FOLLOWING AND FOLLOWERS
  # User is following many other users. The foreign key on the Follows table is 'following_user_id'.
  has_many :followings, foreign_key: 'following_user_id', class_name: 'Follow', dependent: :destroy
  # User has many followed_users through Follows.
  has_many :followed_users, through: :followings, source: :followed_user
  # User has many followers. The foreign key on the Follows table is 'followed_user_id'.
  has_many :followers, foreign_key: 'followed_user_id', class_name: 'Follow', dependent: :destroy
  # User has many following_users through Follows. This is the users FOLLOWING the user
  has_many :following_users, through: :followers, source: :following_user

  # POSTS
  has_many :posts, dependent: :destroy

  # BLOCKED USERS AND BLOCKED BY USERS
  has_many :blocks, dependent: :destroy
  has_many :blocked_users, through: :blocks
  has_many :blocked_by, foreign_key: :blocked_user_id, class_name: 'Block', dependent: :destroy
  has_many :blocked_by_users, through: :blocked_by, source: :user

  # Return list of all user IDs that have blocked this user and this user has blocked.
  def hidden_user_ids
    self.blocked_users.pluck(:id) + self.blocked_by_users.pluck(:id)
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def destroy_blocks_with_blocked_user
    Block.where(blocked_user_id: id).destroy_all
  end
end
