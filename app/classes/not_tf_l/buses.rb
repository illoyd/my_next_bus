class NotTfL::Buses
  BASE_URI          = 'http://countdown.api.tfl.gov.uk/interfaces/ura/instant_V1'
  PREDICTION_FIELDS = %w( StopPointName StopID StopCode1 StopCode2 StopPointType Towards Bearing StopPointIndicator StopPointState Latitude Longitude VisitNumber LineID LineName DirectionID DestinationText DestinationName VehicleID TripID RegistrationNumber EstimatedTime ExpireTime )
  MESSAGE_FIELDS    = %w( StopPointName StopID StopCode1 StopCode2 StopPointType Towards Bearing StopPointIndicator StopPointState Latitude Longitude MessageUUID MessageType MessagePriority MessageText StartTime ExpireTime )
  FIELDS            = ( PREDICTION_FIELDS + MESSAGE_FIELDS ).uniq
  
  def initialize
    RestClient.log = Rails.logger
  end
  
  def get(query)
    RestClient.get(BASE_URI, params: base_query.merge(query))
  end
  
  def stop(stop_id)
    transform( get('StopCode1' => stop_id) )
  end
  
  protected
  
  def transform(response)
    predictions = NotTfL::Response.new
    response.each_line do |line|
      predictions << parse(JSON.parse(line))
    end
    predictions
  end
  
  def parse(response)
    case response.shift
    
    # Prediction
    when 1, '1'
      prediction(response)
    
    # Flexible Message
    when 2, '2'
      message(response)
    
    # Otherwise, ignore
    else
      nil
    
    end
  end
  
  def prediction(response)
    NotTfL::Prediction.new Hash[PREDICTION_FIELDS.zip(response)]
  end
  
  def message(response)
    NotTfL::Message.new Hash[MESSAGE_FIELDS.zip(response)]
  end

  def base_query
    { 'ReturnList' => FIELDS.join(',') }
  end

end