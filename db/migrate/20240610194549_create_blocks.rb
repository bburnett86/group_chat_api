class CreateBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :blocks, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :blocked_user, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
