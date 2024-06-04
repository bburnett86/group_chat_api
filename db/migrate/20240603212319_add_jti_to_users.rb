# frozen_string_literal: true

# This migration adds a `jti` column to the `users` table.
class AddJtiToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :jti, :string
    add_index :users, :jti
  end
end
