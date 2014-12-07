class ToggleFavoriteDestinationJob < ActiveJob::Base
  queue_as :default

  def perform(user, city, destination)
    favorite = user.favorite_destinations.find_or_initialize_by(city: city, destination: destination)
    favorite.toggle!(:favorite)
  end

end
