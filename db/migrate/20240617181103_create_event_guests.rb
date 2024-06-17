class CreateEventGuests < ActiveRecord::Migration[6.1]
  def change
    create_table :event_guests, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid :user_id, null: false
      t.uuid :event_id, null: false
      t.string :status, default: 'PENDING'
      t.string :role, default: 'GUEST'

      t.timestamps
    end

    add_index :event_guests, :user_id
    add_index :event_guests, :event_id

    add_foreign_key :event_guests, :users
    add_foreign_key :event_guests, :events
  end
end