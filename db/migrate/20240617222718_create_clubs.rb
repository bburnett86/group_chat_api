class CreateClubs < ActiveRecord::Migration[7.1]
  def change
    create_table :clubs, id: :uuid do |t|
      t.string :name
      t.string :about_us
      t.boolean :public

      t.timestamps
    end
  end
end