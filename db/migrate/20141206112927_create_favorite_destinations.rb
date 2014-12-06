class CreateFavoriteDestinations < ActiveRecord::Migration
  def change
    create_table :favorite_destinations do |t|
      t.references :user,    index: true
      t.string :city,        index: true
      t.string :stop_sid,    index: true
      t.string :destination, index: true
      t.boolean :favorite,   index: true

      t.timestamps null: false
    end
  end
end
