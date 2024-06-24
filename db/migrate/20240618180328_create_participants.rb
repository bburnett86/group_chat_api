class CreateParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :participants, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid :user_id, null: false
      t.string :participable_type, null: false
      t.uuid :participable_id, null: false
      t.string :status, default: "PENDING"
      t.string :role, default: "MEMBER"

      t.timestamps
    end

    add_index :participants, [:participable_type, :participable_id], name: "index_participants_on_participable_type_and_id"
    add_index :participants, :user_id, name: "index_participants_on_user_id"
  end
end
