class ActiveSessionTracker
  
  def initialize(user, session_duration = 30.minutes)
    @user = user
    @session_duration = session_duration
  end
  
  def cache_key
    "user:#{ @user.id }:last_visited_at"
  end
  
  def last_visited_at
    @last_visited_at ||= Redis.current.get(cache_key)
  end
  
  def new_session?
    last_visited_at.blank?
  end
  
  def active_session?
    last_visited_at.present?
  end
  
  def record_visit
    Redis.current.setex(cache_key, @session_duration, Time.now)
  end

end
