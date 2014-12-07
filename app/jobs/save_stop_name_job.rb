class SaveStopNameJob < ActiveJob::Base

  def perform(city, stop_id, label)
    TransitStop.find_or_create_by(stop_id: stop_id, city: city).tap do |stop|
      stop.name = label
      stop.save
    end
  end

end