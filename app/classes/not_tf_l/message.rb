class NotTfL::Message < Hashie::Trash

  property :uuid,      from: 'MessageUUID'     
  property :text,      from: 'MessageText'
  property :type,      from: 'MessageType'
  property :priority,  from: 'MessagePriority'
  property :start_at,  from: 'StartTime',  with: ->(value) { Time.at( value.to_f / 1000 ) }
  property :expire_at, from: 'ExpireTime', with: ->(value) { Time.at( value.to_f / 1000 ) }

end