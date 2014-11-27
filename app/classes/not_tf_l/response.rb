class NotTfL::Response

  def initialize
    @predictions = []
    @messages = []
  end
  
  def <<(value)
    case value
    when NotTfL::Prediction
      @predictions << value
    when NotTfL::Message
      @messages << value
    else
      # Do nothing
    end
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
  
  def active_messages
    @messages.select{ |msg| msg.start_at.past? && msg.expire_at.future? }.sort_by(&:priority)
  end

  def routes
    @predictions.map{ |prediction| prediction.line_name }.uniq.compact.sort
  end
  
  def stop_name
    @predictions.first.stop_name
  end
  
  def stop_indicator
    @predictions.first.stop_indicator
  end
  
  def predictions?
    @predictions.any?
  end
  
end