class NotTfL::Buses
  BASE_URI          = 'http://countdown.api.tfl.gov.uk/interfaces/ura/instant_V1'
  STOP_FIELDS       = %w( StopPointName StopID StopCode1 StopCode2 StopPointType Towards Bearing StopPointIndicator StopPointState Latitude Longitude )
  PREDICTION_FIELDS = %w( StopPointName StopID StopCode1 StopCode2 StopPointType Towards Bearing StopPointIndicator StopPointState Latitude Longitude VisitNumber LineID LineName DirectionID DestinationText DestinationName VehicleID TripID RegistrationNumber EstimatedTime ExpireTime )
  MESSAGE_FIELDS    = %w( StopPointName StopID StopCode1 StopCode2 StopPointType Towards Bearing StopPointIndicator StopPointState Latitude Longitude MessageUUID MessageType MessagePriority MessageText StartTime ExpireTime )
  FIELDS            = ( STOP_FIELDS + PREDICTION_FIELDS + MESSAGE_FIELDS ).uniq
  
  STOP_DEFAULT_FIELDS = %w( StopPointName StopCode1 StopPointType StopPointIndicator StopPointState LineID LineName DestinationText TripID EstimatedTime ExpireTime MessageUUID MessageType MessagePriority MessageText StartTime ExpireTime )
  NEAR_DEFAULT_FIELDS = %w( StopPointName StopCode1 StopPointType StopPointIndicator StopPointState Latitude Longitude )
  TRIP_DEFAULT_FIELDS = %w( StopPointName StopCode1 StopPointType StopPointIndicator StopPointState LineID LineName DestinationText TripID EstimatedTime ExpireTime MessageUUID MessageType MessagePriority MessageText StartTime ExpireTime )
  
  def initialize
    RestClient.log = Rails.logger
  end
  
  def get(query)
    RestClient.get(BASE_URI, params: base_query.merge(query))
  end
  
  def stop(stop_sid)
    transform(get(
      'StopCode1' => stop_sid,
      'ReturnList' => STOP_DEFAULT_FIELDS.join(','),
      'StopAlso' => true
    ), STOP_DEFAULT_FIELDS)
  end
  
  def trip(trip_sid)
    transform(get(
      'TripID' => trip_sid,
      'ReturnList' => TRIP_DEFAULT_FIELDS.join(','),
      'StopAlso' => true
    ), STOP_DEFAULT_FIELDS)
  end
  
  def near(latitude, longitude, radius = 1000)
    transform(get(
      'Circle' => "#{ latitude },#{ longitude },#{ radius }",
      'ReturnList' => NEAR_DEFAULT_FIELDS.join(','),
      'StopAlso' => true
    ), NEAR_DEFAULT_FIELDS)
  end
  
  protected
  
  def transform(response, return_fields)
    predictions = NotTfL::Response.new
    response.each_line do |line|
      predictions << parse(JSON.parse(line), return_fields)
    end
    predictions
  end
  
  def parse(response, return_fields)
    case response.shift
    
    # Prediction
    when 1, '1'
      prediction(response, return_fields)
    
    # Flexible Message
    when 2, '2'
      message(response, return_fields)
    
    # Flexible Message
    when 0, '0'
      build_stop(response, return_fields)
    
    # Otherwise, ignore
    else
      nil
    
    end
  end
  
  def build_stop(response, return_fields)
    NotTfL::Stop.new build_response_hash(STOP_FIELDS, return_fields, response)
  end

  def prediction(response, return_fields)
    NotTfL::Prediction.new build_response_hash(PREDICTION_FIELDS, return_fields, response)
  end
  
  def message(response, return_fields)
    NotTfL::Message.new build_response_hash(MESSAGE_FIELDS, return_fields, response)
  end

  def base_query
    { 'ReturnList' => FIELDS.join(',') }
  end
  
  def build_response_hash(all_keys, keys, values)
    keys = all_keys & keys
    Hash[keys.zip(values)]
  end

end