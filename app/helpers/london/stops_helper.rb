module London::StopsHelper
  
  REPLACEMENT_DICTIONARY = {
    'North' => 'N.',
    'East'  => 'E.',
    'South' => 'S.',
    'West'  => 'W.',
  }
  
  DueThreshold = 45
  
  def minutes_label_for(prediction)
    if due?(prediction)
      'due'
    else
      minutes_for(prediction)
    end
  end
  
  def next_label_for(prediction)
    delta = ( prediction.estimated_arrival - Time.now )
    return 'due' if delta < DueThreshold
    minutes = ( delta / 60.to_f ).floor
    seconds = fraction_for delta.modulo(60).round, 30
    "#{ minutes }#{ seconds }".html_safe
  end
  
  def then_label_for(prediction)
    delta = ( prediction.estimated_arrival - Time.now )
    return 'due' if delta < DueThreshold
    minutes = ( delta / 60.to_f ).ceil
    "#{ minutes }".html_safe
  end

  def minutes_for(prediction)
    delta = ( prediction.estimated_arrival - Time.now )
    minutes = ( delta / 60.to_f ).floor
    seconds = fraction_for delta.modulo(60).round, 30
    "#{ minutes }#{ seconds }".html_safe
  end
  
  def fraction_for(value, round_to)
    if value < 15
      '&frac14;'
    elsif value < 30
      '&frac12;'
    elsif value < 45
      '&frac34;'
    end
  end
  
  def due?(prediction)
    ( prediction.estimated_arrival - Time.now ) < DueThreshold
  end
  
  def simplify_destination(prediction)
    destination = prediction.destination.dup
    
    REPLACEMENT_DICTIONARY.each { |k,v| destination.gsub!(/\b#{ k }\b/, v) }

    destination
  end

end
