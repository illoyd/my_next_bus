class CreateOrUpdateStopJob < ActiveJob::Base

  def perform(city, stop)
    stop = NotTfL::Stop.new(stop)

    TransitStop.find_or_initialize_by(stop_sid: stop.code1, city: city).tap do |ss|
      ss.name      ||= stop.name
      ss.indicator ||= stop.indicator
      ss.towards   ||= stop.towards
      ss.latitude  ||= stop.latitude
      ss.longitude ||= stop.longitude
      ss.save!
    end
  end

end