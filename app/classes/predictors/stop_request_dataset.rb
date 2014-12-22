class Predictors::StopRequestDataset

  def self.create(stop_data)
    Ai4r::Data::DataSet.new(data_items: stop_data, data_labels: default_data_labels)
  end
  
  def self.for(user)
    create StopDataForPredictorDatasetQuery.for(user)
  end
  
  protected
  
  def self.default_data_labels
    %w( day_of_week minute_of_day stop_sid )
  end

end