class FavoriteDestination < ActiveRecord::Base
  belongs_to :user, inverse_of: :favorite_destinations

  scope :favorites, ->{ where(favorite: true) }
  scope :destinations, ->{ pluck(:destination) }
end
