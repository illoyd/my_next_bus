class AddCityToTripRequests < ActiveRecord::Migration
  def change
    add_column :trip_requests, :city, :string, index: true
  end
end
