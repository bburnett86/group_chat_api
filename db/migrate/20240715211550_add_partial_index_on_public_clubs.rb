class AddPartialIndexOnPublicClubs < ActiveRecord::Migration[6.0]
  def change
    add_index :clubs, :id, where: "public = TRUE", name: "index_clubs_on_id_public"
  end
end