class CreateIntents < ActiveRecord::Migration
  def change
    create_table :intents do |t|

      t.string     :type,          index: true, null: false
      t.references :user,          index: true, null: false
      t.string     :city,          index: true, null: false
      t.integer    :day_of_week,                null: false
      t.integer    :minute_of_day,              null: false
      t.hstore     :properties

      t.timestamps null: false
    end
  end
end
