class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :title, default: ''
      t.string :description, default: ''
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :active, default: true

      t.timestamps
    end
  end
end