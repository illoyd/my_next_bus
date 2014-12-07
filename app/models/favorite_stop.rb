class FavoriteStop < ActiveRecord::Base
  belongs_to :user
  
  scope :favorites, ->{ where(favorite: true) }
  scope :stop_sids, ->{ pluck(:stop_sid) }
end
