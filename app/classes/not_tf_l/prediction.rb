class NotTfL::Prediction < Hashie::Trash
  include Hashie::Extensions::Dash::IndifferentAccess
  
  property :stop_name,         from: 'StopPointName'
  property :stop_sid,          from: 'StopID'
  property :stop_code1,        from: 'StopCode1'
  property :stop_code2,        from: 'StopCode2'
  property :stop_type,         from: 'StopPointType'
  property :towards,           from: 'Towards'
  property :bearing,           from: 'Bearing'
  property :stop_indicator,    from: 'StopPointIndicator'
  property :stop_state,        from: 'StopPointState',    with: NotTfL::Buses::StopPointStateTransformer

  property :latitude,          from: 'Latitude'
  property :longitude,         from: 'Longitude'

  property :visit_number,      from: 'VisitNumber'
  property :line_id,           from: 'LineID'
  property :line_name,         from: 'LineName'
  property :direction_id,      from: 'DirectionID'

  property :destination_id,    from: 'DestinationText'
  property :destination_text,  from: 'DestinationText'
  property :destination_name,  from: 'DestinationName'

  property :vehicle_id,        from: 'VehicleID'
  property :trip_id,           from: 'TripID'
  property :registration_number, from: 'RegistrationNumber'
  
  property :estimated_arrival, from: 'EstimatedTime', with: ->(value) { Time.at( value.to_f / 1000 ) }
  property :expire_at,         from: 'ExpireTime', with: ->(value) { Time.at( value.to_f / 1000 ) }
  
  alias :destination :destination_text
  
  def expired?
    return true if expire_at.try(:past?)
    false
  end

  def show_stop?
    NotTfL::Stop::ShowableStopTypes.include?(stop_type)
  end
  
  delegate :open?, :temporarily_closed?, :closed?, :suspended?, to: :stop_state

end