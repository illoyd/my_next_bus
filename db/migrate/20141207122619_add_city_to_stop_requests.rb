class AddCityToStopRequests < ActiveRecord::Migration
  def change
    add_column :stop_requests, :city, :string, index: true
  end
end
