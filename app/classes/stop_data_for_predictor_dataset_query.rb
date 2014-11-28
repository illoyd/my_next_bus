class StopDataForPredictorDatasetQuery < SimpleDelegator

  ##
  # Create a new query for direct use with the PredictorDataset object. Data is provided
  # in the order :day_of_week, :minute_of_day, :stop_id.
  # Accepts a +base+ object that must include or be descended from a StopRequest relation.
  def initialize(base = StopRequest, window = 8.weeks.ago)
    __setobj__ base.where('created_at >= ? and stop_id is not null and day_of_week is not null and minute_of_day is not null', window).pluck(:day_of_week, :minute_of_day, :stop_id)
  end
  
  ##
  # Create a new query for the given user.
  def self.for(user)
    new(user.stop_requests)
  end
  
end
