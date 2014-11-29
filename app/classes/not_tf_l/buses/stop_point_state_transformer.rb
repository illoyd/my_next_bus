class NotTfL::Buses::StopPointStateTransformer

  def self.call(value)
    # Convert the state
    state = case value
    when 0, '0'
      'open'
    when 1, '1'
      'temporarily_closed'
    when 2, '2'
      'closed'
    when 3, '3'
      'suspended'
    else
      'unknown'
    end
    
    # Return an enquirererererer
    ActiveSupport::StringInquirer.new(state)
  end

end