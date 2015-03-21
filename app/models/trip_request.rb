class TripRequest < Intent
  store_accessor :properties, :trip_sid, :line_name, :destination

  validates_presence_of :trip_sid, :line_name, :destination

end
