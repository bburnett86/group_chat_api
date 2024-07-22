# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :description, default: ''
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.boolean :close_friends, default: false
      t.string :postable_type
      t.uuid :postable_id

      t.timestamps
    end

    add_index :posts, [:user_id, :postable_type, :postable_id]
  end
end
