class StopsForm
  include ActiveModel::Model
  
  attr_accessor :stop, :lat, :lon
  attr_accessor :predicted_stop_sid, :predicted_stop
  
  validates :stop, presence: true
  
  def predicted_stop_sid
    @predicted_stop_sid ||= 72350
  end
  
  def predicted_stop
    @predicted_stop ||= TransitStop.find_by(stop_id: predicted_stop_sid) if predicted_stop_sid
  end
  
  def nearby_stops
    @nearby_stops ||= (lat? && lon?) ? find_nearby_stops : []
  end
  
  def nearby_stops?
    nearby_stops.any?
  end
  
  def lat?
    @lat.present?
  end
  
  def lon?
    @lon.present?
  end
  
  protected

  def find_nearby_stops
    NotTfL::Buses.new.nearby_stops(lat, lon)
  end
end