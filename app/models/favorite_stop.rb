class FavoriteStop < ActiveRecord::Base
  belongs_to :user
  
  scope :stop_sids, ->{ pluck(:stop_sid) }
end
