class CreateFavoriteStops < ActiveRecord::Migration
  def change
    create_table :favorite_stops do |t|
      t.references :user,    index: true, null: false
      t.string :city,        index: true, null: false
      t.string :stop_sid,    index: true, null: false
      t.boolean :favorite,   index: true, null: false, default: false

      t.timestamps null: false
    end
  end
end
