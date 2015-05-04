class RecordTripRequestJob < ActiveJob::Base
  queue_as :background

  def perform(user, city, trip_id)
    
    # Get the line name from the bus system
    prediction  = NotTfL::CachedBuses.new.trip(trip_id).predictions.first
    line_name   = prediction.try(:line_name)
    destination = prediction.try(:destination_text)

    # If we have a user and a line name, proceed with recording
    if user
      TripRequest.create(user: user, city: city, trip_sid: trip_id, line_name: line_name, destination: destination)
    end
  end

end