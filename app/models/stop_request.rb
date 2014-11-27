class StopRequest < ActiveRecord::Base
  belongs_to :user, inverse_of: :stop_requests
  
  before_validation :ensure_day_of_week, :ensure_minute_of_day
  
  validates_presence_of :day_of_week, :minute_of_day, :user
  
  def ensure_day_of_week
    tt = self.created_at || Time.now
    self.day_of_week = tt.wday
  end
  
  def ensure_minute_of_day
    tt = self.created_at || Time.now
    self.minute_of_day = tt.hour * 60 + tt.min
  end
end
