# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :description, default: ''
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.boolean :close_friends, default: false

      t.timestamps
    end
  end
end
