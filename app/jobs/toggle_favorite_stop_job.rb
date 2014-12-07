class ToggleFavoriteStopJob < ActiveJob::Base
  queue_as :default

  def perform(user, city, stop_sid)
    favorite = user.favorite_stops.find_or_initialize_by(city: city, stop_sid: stop_sid)
    favorite.toggle!(:favorite)
  end

end
