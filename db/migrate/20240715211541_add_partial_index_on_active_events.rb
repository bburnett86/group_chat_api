class AddPartialIndexOnActiveEvents < ActiveRecord::Migration[6.0]
  def change
    add_index :events, :id, where: "active = TRUE", name: "index_events_on_id_active"
  end
end