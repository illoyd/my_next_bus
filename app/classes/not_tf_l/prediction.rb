class NotTfL::Prediction < Hashie::Trash
  
  property :stop_name,         from: 'StopPointName'     
  property :stop_indicator,    from: 'StopPointIndicator'
  property :stop_state,        from: 'StopPointState'
  property :line_name,         from: 'LineName'
  property :destination,       from: 'DestinationText'
  property :estimated_arrival, from: 'EstimatedTime', with: ->(value) { Time.at( value.to_f / 1000 ) }

end