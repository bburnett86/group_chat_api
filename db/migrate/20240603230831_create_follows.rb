# frozen_string_literal: true

# The CreateFollows class is a migration that creates the 'follows' table in the database.
# This table is used to store the relationships between users in a social networking context,
# where one user (the follower) can follow another user (the followee).
class CreateFollows < ActiveRecord::Migration[7.1]
  def change
    create_table :follows, id: :uuid do |t|
      t.uuid :following_user_id
      t.uuid :followed_user_id

      t.timestamps
    end
  end
end
