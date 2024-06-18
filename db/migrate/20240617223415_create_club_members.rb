class CreateClubMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :club_members, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid :user_id, null: false
      t.uuid :club_id, null: false
      t.string :status, default: 'PENDING'
      t.string :role, default: 'STANDARD'

      t.timestamps
    end

    add_index :club_members, :user_id
    add_index :club_members, :club_id

    add_foreign_key :club_members, :users
    add_foreign_key :club_members, :clubs
  end
end
