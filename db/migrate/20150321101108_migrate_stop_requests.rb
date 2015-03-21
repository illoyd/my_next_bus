class MigrateStopRequests < ActiveRecord::Migration
  class OldStopRequest < ActiveRecord::Base
    belongs_to :user
    self.table_name = 'stop_requests'
  end

  def up
    OldStopRequest.where(user_id: User.ids).where('stop_sid is not null').find_each do |old|
      StopRequest.create!(
        user_id:       old.user_id,
        city:          old.city || 'london',
        stop_sid:      old.stop_sid,
        day_of_week:   old.day_of_week,
        minute_of_day: old.minute_of_day,
        created_at:    old.created_at,
        updated_at:    old.updated_at
      )
    end
  end
  
  def down
    # Do nothing
  end
end
