class CreateTripRequests < ActiveRecord::Migration
  def change
    create_table :trip_requests do |t|
      t.references :user,       index: true
      t.string  :line_name,                  null: false
      t.integer :day_of_week,                null: false
      t.integer :minute_of_day,              null: false

      t.timestamps null: false
    end
  end
end
