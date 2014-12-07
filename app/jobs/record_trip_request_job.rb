class RecordTripRequestJob < ActiveJob::Base
  queue_as :background

  def perform(user, city, trip_id)
    
    # Get the line name from the bus system
    line_name = NotTfL::CachedBuses.new.trip(trip_id).predictions.first.try(:line_name)

    # If we have a user and a line name, proceed with recording
    if user && line_name
      user.trip_requests.create(city: city, line_name: line_name)
    end
  end

end