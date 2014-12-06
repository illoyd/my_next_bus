class FavoriteDestination < ActiveRecord::Base
  belongs_to :user, inverse_of: :favorite_destinations
end
