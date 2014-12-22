class ChangeStopRequestStopIdToStopSid < ActiveRecord::Migration
  def change
    rename_column :stop_requests, :stop_id, :stop_sid
  end
end
