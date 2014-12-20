class StopSuggester
  
  attr_reader :user
  
  def initialize(u)
    @user = u
  end
  
  def show?
    @user && prediction?
  end
  
  def redirect?
    @user && ActiveSessionTracker.new(@user).new_session?
  end

  def prediction
    return nil unless @user
    @prediction ||= @user.predictor.predict_now
  end
  
  def prediction?
    prediction.present?
  end
  
  def stop
    return nil unless prediction?
    @stop ||= TransitStop.create_with(name: prediction).find_or_create_by(stop_id: prediction)
  end
  
  def stop?
    prediction? && stop.present?
  end
  
  def cache_key
    [ prediction, redirect? ]
  end
  
end