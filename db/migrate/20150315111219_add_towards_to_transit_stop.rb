class AddTowardsToTransitStop < ActiveRecord::Migration
  def change
    add_column :transit_stops, :towards, :string
  end
end
