# frozen_string_literal: true

# Migration class for creating the users table and adding Devise columns.
class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto'
    create_users_table
    add_indexes_to_users_table
  end

  def create_users_table
    create_table :users, id: :uuid do |table|
      create_columns(table)
      table.timestamps null: false
    end
  end

  def create_columns(table)
    create_email_column(table)
    create_encrypted_password_column(table)
    create_reset_password_columns(table)
    create_rememberable_columns(table)
    create_trackable_columns(table)
    create_lockable_columns(table)
    create_additional_columns(table)
  end

  def create_email_column(table)
    table.string :email, null: false, default: ''
  end

  def create_encrypted_password_column(table)
    table.string :encrypted_password, null: false, default: ''
  end

  def create_reset_password_columns(table)
    table.string   :reset_password_token
    table.datetime :reset_password_sent_at
  end

  def create_rememberable_columns(table)
    table.datetime :remember_created_at
  end

  def create_trackable_columns(table)
    table.integer  :sign_in_count, default: 0, null: false
    table.datetime :current_sign_in_at
    table.datetime :last_sign_in_at
    table.string   :current_sign_in_ip
    table.string   :last_sign_in_ip
  end

  def create_lockable_columns(table)
    table.integer  :failed_attempts, default: 0, null: false
    table.string   :unlock_token
    table.datetime :locked_at
  end

  def create_additional_columns(table)
    table.string :username, default: ''
    table.boolean :show_email, default: false
    table.string :bio, default: ''
    table.boolean :active, default: true
    table.string :role, default: 'STANDARD'
    table.string :avatar_url, default: ''
  end

  def add_indexes_to_users_table
    add_index :users, :username,             unique: true
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
