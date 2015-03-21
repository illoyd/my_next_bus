class StopRequest < Intent
  store_accessor :properties, :stop_sid

  validates_presence_of :stop_sid

end
