class ActivityTimelineQuery < SimpleDelegator

  def initialize(base = StopRequest, window = 8.weeks.ago)
    __setobj__ base.where('created_at >= ?', window).order('day_of_week, stop_id, minute_of_day')
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
    attr_reader :day_of_week, :stop_id, :start_minute_of_day, :end_minute_of_day

    def initialize(request)
      @day_of_week         = request.day_of_week
      @stop_id             = request.stop_id
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
      (@start_minute_of_day.to_f / 60).floor
    end
    
    def starting_minute
      @start_minute_of_day.modulo(60)
    end
    
    def ending_hour
      (@end_minute_of_day.to_f / 60).floor
    end
    
    def ending_minute
      @end_minute_of_day.modulo(60)
    end
    
    def contiguous?(request)
      request.day_of_week == @day_of_week &&
        request.stop_id == @stop_id &&
        request.minute_of_day <= (@end_minute_of_day + 2)
    end
    
    def update(request)
      @end_minute_of_day = request.minute_of_day if @end_minute_of_day < request.minute_of_day
    end
    
    def to_a
      [ weekday, stop_id, start_time, end_time ]
    end

    def minute_to_time(minute)
      "#{ (minute.to_f / 60).floor }:#{ minute.modulo(60) }"
    end
    
  end

end
