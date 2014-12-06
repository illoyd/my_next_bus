class TopStopsForUserQuery < SimpleDelegator

  def initialize(base = User)
    __setobj__ TransitStop.where(stop_id: base.stop_requests.top([:stop_id], 5).map(&:first))
  end
  
end
