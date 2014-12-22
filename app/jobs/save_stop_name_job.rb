class SaveStopNameJob < ActiveJob::Base

  def perform(city, stop_sid, label)
    TransitStop.find_or_create_by(stop_sid: stop_sid, city: city).tap do |stop|
      stop.name = label
      stop.save
    end
  end

end