class NotTfL::Message < Hashie::Trash

  property :stop_name,         from: 'StopPointName'
  property :stop_id,           from: 'StopID'
  property :stop_code1,        from: 'StopCode1'
  property :stop_code2,        from: 'StopCode2'
  property :stop_type,         from: 'StopPointType'
  property :towards,           from: 'Towards'
  property :bearing,           from: 'Bearing'
  property :stop_indicator,    from: 'StopPointIndicator'
  property :stop_state,        from: 'StopPointState'

  property :latitude,          from: 'Latitude'
  property :longitude,         from: 'Longitude'

  property :uuid,              from: 'MessageUUID'     
  property :type,              from: 'MessageType'
  property :priority,          from: 'MessagePriority'
  property :text,              from: 'MessageText'

  property :start_at,          from: 'StartTime',  with: ->(value) { Time.at( value.to_f / 1000 ) }
  property :expire_at,         from: 'ExpireTime', with: ->(value) { Time.at( value.to_f / 1000 ) }

  def started?
    return false if start_at.try(:future?)
    true
  end

  def expired?
    return true if expire_at.try(:past?)
    false
  end

  def active?
    started? && !expired?
  end

end