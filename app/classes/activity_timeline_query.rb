class ActivityTimelineQuery < SimpleDelegator

  def initialize(base = StopRequest, window = 8.weeks.ago)
    __setobj__ base.where('created_at >= ?', window).order('day_of_week, properties->\'stop_sid\', minute_of_day')
  end
  
  def self.for(user)
    new(user.stop_requests)
  end
  
  def to_dataset
    current = nil
    self.each_with_object([]) do |r, a|
      # Attempt to update
      if current && current.contiguous?(r)
        current.update(r)
      else
        current = Entry.new(r)
        a << current
      end
      
    end
  end
  
  class Entry
    attr_reader :day_of_week, :stop_sid, :start_minute_of_day, :end_minute_of_day

    def initialize(request)
      @day_of_week         = request.day_of_week
      @stop_sid            = request.stop_sid
      @start_minute_of_day = request.minute_of_day
      @end_minute_of_day   = request.minute_of_day
    end
    
    def weekday
      Date::ABBR_DAYNAMES[@day_of_week]
    end
    
    def start_time
      minute_to_time(@start_minute_of_day)
    end
    
    def end_time
      minute_to_time(@end_minute_of_day)
    end
    
    def starting_hour
      hour_from_minutes(@start_minute_of_day)
    end
    
    def starting_minute
      minute_from_minutes(@start_minute_of_day)
    end
    
    def ending_hour
      hour_from_minutes(@end_minute_of_day)
    end
    
    def ending_minute
      minute_from_minutes(@end_minute_of_day)
    end
    
    def contiguous?(request)
      request.day_of_week == @day_of_week &&
        request.stop_sid == @stop_sid &&
        request.minute_of_day <= (@end_minute_of_day + 2)
    end
    
    def update(request)
      @end_minute_of_day = request.minute_of_day if @end_minute_of_day < request.minute_of_day
    end
    
    def to_a
      [ weekday, stop_sid, start_time, end_time ]
    end
    
    def hour_from_minutes(minutes)
      (minutes.to_f / 60).floor
    end
    
    def minute_from_minutes(minutes)
      minutes.modulo(60)
    end

    def minute_to_time(minutes)
      "#{ hour_from_minutes(minutes) }:#{ minute_from_minutes(minutes) }"
    end
    
  end

end
