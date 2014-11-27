class CreateStopRequests < ActiveRecord::Migration
  def change
    create_table :stop_requests do |t|
      t.references :user,       index: true
      t.integer :stop_id,                    null: false
      t.integer :day_of_week,                null: false
      t.integer :minute_of_day,              null: false

      t.timestamps null: false
    end
  end
end
