class NotTfL::Response

  def initialize
    @stops       = []
    @predictions = []
    @messages    = []
  end
  
  def <<(value)
    case value
    when NotTfL::Prediction
      @predictions << value
    when NotTfL::Message
      @messages << value
    when NotTfL::Stop
      @stops << value
    else
      # Do nothing
    end
  end
  
  def stops?
    @stops.any?
  end
  
  def stop
    @stops.first
  end
  
  def stops
    @stops
  end
  
  def stop_name
    stop.name
  end
  
  def stop_indicator
    stop.indicator
  end
  
  def predictions?
    @predictions.any?
  end
  
  def predictions
    @predictions.sort_by(&:estimated_arrival)
  end
  
  def predictions_by_line
    predictions.group_by(&:line_name)
  end
  
  def predictions_by_destination
    predictions.group_by(&:destination)
  end
  
  def predictions_by_destination_and_line
    by_destination = predictions_by_destination
    by_destination.each { |destination,predictions| by_destination[destination] = predictions.group_by(&:line_name) }
  end
  
  def messages
    @messages
  end
  
  def messages?
    @messages.any?
  end
  
  def active_messages
    @messages.select(&:active?).sort_by(&:priority)
  end

  def active_messages?
    active_messages.any?
  end
  
  def high_priority_messages
    active_messages.select{ |msg| [1,2].include?(msg.priority) }
  end
  
  def non_high_priority_messages
    active_messages.reject{ |msg| [1,2].include?(msg.priority) }
  end
  
  def routes
    @predictions.map(&:line_name).uniq.compact.sort
  end
  
end