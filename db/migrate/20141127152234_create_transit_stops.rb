class CreateTransitStops < ActiveRecord::Migration
  def change
    create_table :transit_stops do |t|
      t.string :city
      t.string :stop_id
      t.string :name

      t.timestamps null: false
    end
  end
end
