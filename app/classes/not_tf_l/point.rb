class NotTfL::Point
  attr_reader :lat, :lon
  
  RAD_PER_DEG        = Math::PI / 180
  EARTH_RADIUS_IN_KM = 6371
  EARTH_RADIUS_IN_M  = EARTH_RADIUS_IN_KM * 1000
  
  def initialize(lat, lon)
    @lat = lat.to_f
    @lon = lon.to_f
  end
  
  def to_radians
    new(lat * RAD_PER_DEG, lon * RAD_PER_DEG)
  end
  
  def distance_between(other)
    dlon_rad = (other.lon - self.lon) * RAD_PER_DEG  # Delta, converted to rad
    dlat_rad = (other.lat - self.lat) * RAD_PER_DEG
    
    self_rad  = self.to_radians
    other_rad = other.to_radians

    a = Math.sin(dlat_rad/2)**2 + Math.cos(self_rad.lat) * Math.cos(other_rad.lat) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
  
    EARTH_RADIUS_IN_M * c # Delta in meters
  end

end