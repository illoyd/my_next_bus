class NotTfL::Stop < Hashie::Trash
  include Hashie::Extensions::Dash::IndifferentAccess
  
  ShowableStopTypes = %w( STBR STBC STZZ STBN STBS STSS STVA SLRS )

  property :name,         from: 'StopPointName'
  property :id,           from: 'StopID'
  property :code1,        from: 'StopCode1'
  property :code2,        from: 'StopCode2'
  property :type,         from: 'StopPointType'
  property :towards,      from: 'Towards'
  property :bearing,      from: 'Bearing'
  property :indicator,    from: 'StopPointIndicator'
  property :state,        from: 'StopPointState',    with: NotTfL::Buses::StopPointStateTransformer

  property :latitude,     from: 'Latitude'
  property :longitude,    from: 'Longitude'

  def show_predictions?
    !(state.closed? || state.suspended?)
  end
  
  def show?
    ShowableStopTypes.include?(type) && (id.present? || code1.present? || code2.present?)
  end
  
  def distance_between(other_point)
    other_point = other_point.point if other_point.respond_to?(:point)
    self.point.distance_between(other_point)
  end
  
  def point
    @point ||= NotTfL::Point.new(latitude, longitude)
  end
  
  delegate :open?, :temporarily_closed?, :closed?, :suspended?, to: :state
  
  alias_method :stop_sid, :code1

end