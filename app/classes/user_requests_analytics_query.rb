class UserRequestsAnalyticsQuery < SimpleDelegator

  def initialize(base = StopRequest)
    __setobj__ base.where('created_at >= ?', 8.weeks.ago).group(:stop_id, :day_of_week, :minute_of_day).count(:stop_id)
  end
  
  def self.for(user)
    new(user.stop_requests)
  end

end
