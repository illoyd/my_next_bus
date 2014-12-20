module London::StopsHelper
  
  REPLACEMENT_DICTIONARY = {
    'North' => 'N.',
    'East'  => 'E.',
    'South' => 'S.',
    'West'  => 'W.',
  }
  
  DueThreshold = 45
  RoundingThreshold = 15
  
  def minutes_label_for(prediction)
    if due?(prediction)
      'due'
    else
      minutes_for(prediction)
    end
  end
  
  def round_seconds_to_arrival(seconds)
    seconds + seconds.modulo(RoundingThreshold)
  end
  
  def next_label_for(prediction)
    delta = ( prediction.estimated_arrival - Time.now )
    return 'due' if delta < DueThreshold
    delta = round_seconds_to_arrival(delta)
    minutes = ( delta / 60.to_f ).floor
    seconds = fraction_for delta.modulo(60).round, 30
    "#{ minutes }#{ seconds }".html_safe
  end
  
  def then_label_for(prediction)
    delta = ( prediction.estimated_arrival - Time.now )
    return 'due' if delta < DueThreshold
    delta = round_seconds_to_arrival(delta)
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
  
  def distance_between(a, b)
    
    a[0] = a[0].to_f
    a[1] = a[1].to_f
    b[0] = b[0].to_f
    b[1] = b[1].to_f
    
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters
  
    dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
    dlat_rad = (b[0]-a[0]) * rad_per_deg
  
    lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }
  
    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
  
    rm * c # Delta in meters
  end

end
