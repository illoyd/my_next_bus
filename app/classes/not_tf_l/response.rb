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
  
  def messages
    @messages
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
  
end