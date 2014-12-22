class ChangeTransitStopStopIdToStopSid < ActiveRecord::Migration
  def change
    rename_column :transit_stops, :stop_id, :stop_sid
  end
end
