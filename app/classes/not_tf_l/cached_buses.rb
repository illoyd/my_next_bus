class NotTfL::CachedBuses < NotTfL::Buses

  def get(query)
    response = get_cache(query)

    unless response.present?
      response = super(query)
      set_cache(query, response)
    end

    response
  end
  
  def get_cache(stop_id)
    $redis.get( cache_key(stop_id) )
  end

  def set_cache(query, response)
    $redis.setex( cache_key(query), 45.seconds, response )
  end
  
  def cache_key(query)
    'buses/' + query.map { |k,v| "#{ k }:#{ v }" }.join('/')
  end

end