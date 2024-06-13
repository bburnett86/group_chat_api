class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes, id: :uuid do |t|
      t.references :liker, null: false, type: :uuid, foreign_key: { to_table: :users }
      t.references :liked, null: false, type: :uuid, foreign_key: { to_table: :users }
      t.references :likeable, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end