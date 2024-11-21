class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments, id: :uuid do |t|
      t.string :description, null: false
      t.references :post, null: false, foreign_key: true, type: :uuid, index: true
      t.references :user, null: false, foreign_key: true, type: :uuid, index: true

      t.timestamps
    end
  end
end