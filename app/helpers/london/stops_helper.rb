module London::StopsHelper
  
  REPLACEMENT_DICTIONARY = {
    'North' => 'N.',
    'East'  => 'E.',
    'South' => 'S.',
    'West'  => 'W.',
  }

  def minutes_for(prediction)
    ( ( prediction.estimated_arrival - Time.now ) / 60 ).round
  end
  
  def minutes_label_for(prediction)
    minutes = minutes_for(prediction)
    minutes = 'due' if minutes == 0
    minutes
  end
  
  def due?(prediction)
    ( prediction.estimated_arrival - Time.now ) < 60
  end
  
  def simplify_destination(prediction)
    destination = prediction.destination.dup
    
    REPLACEMENT_DICTIONARY.each { |k,v| destination.gsub!(k, v) }

    destination
  end

end
