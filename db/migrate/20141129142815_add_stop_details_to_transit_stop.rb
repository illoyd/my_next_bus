class AddStopDetailsToTransitStop < ActiveRecord::Migration
  def change
    add_column :transit_stops, :indicator, :string
    add_column :transit_stops, :latitude, :float
    add_column :transit_stops, :longitude, :float
  end
end
