class TopStopsForUserQuery < SimpleDelegator

  def initialize(base = User)
    # __setobj__ TransitStop.where(stop_sid: base.stop_requests.top(["intents.properties -> 'stop_sid'"], 5).map(&:first))
    top_stops = base.stop_requests.select("properties->'stop_sid'").group("properties->'stop_sid'").limit(5).count
    __setobj__ TransitStop.where(stop_sid: top_stops.map(&:first))
  end
  
end
