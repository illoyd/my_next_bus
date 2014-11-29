class RecordStopRequestJob < ActiveJob::Base
  queue_as :background

  def perform(user, city, stop_id)
    # Find the stop by city and ID
    stop = TransitStop.find_by(city: city, stop_id: stop_id)
    
    # If we have a user and a stop, record the request
    if user && stop
      user.stop_requests.create(stop_id: stop.stop_id)
    end
  end

end