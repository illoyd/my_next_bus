class CreateFavoriteDestinations < ActiveRecord::Migration
  def change
    create_table :favorite_destinations do |t|
      t.references :user,    index: true, null: false
      t.string :city,        index: true, null: false
      t.string :destination, index: true, null: false
      t.boolean :favorite,   index: true, null: false, default: false

      t.timestamps null: false
    end
  end
end
