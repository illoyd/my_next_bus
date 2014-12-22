class RecordStopRequestJob < ActiveJob::Base
  queue_as :background

  def perform(user, city, stop_sid)
    # Find the stop by city and ID
    stop = TransitStop.find_by(city: city, stop_sid: stop_sid)
    
    # If we have a user and a stop, record the request
    if user && stop
      user.stop_requests.create(stop_sid: stop.stop_sid)
    end
  end

end