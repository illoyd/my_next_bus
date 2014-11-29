class NotTfL::Stop < Hashie::Trash
  
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
  
  def show_stop?
    ShowableStopTypes.include?(type)
  end
  
  delegate :open?, :temporarily_closed?, :closed?, :suspended?, to: :state

end