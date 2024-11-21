class AddPartialIndexOnActiveUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :id, where: "active = TRUE", name: "index_users_on_id_active"
  end
end