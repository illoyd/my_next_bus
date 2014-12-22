class TopStopsForUserQuery < SimpleDelegator

  def initialize(base = User)
    __setobj__ TransitStop.where(stop_sid: base.stop_requests.top([:stop_sid], 5).map(&:first))
  end
  
end
