class Predictors::Policy
  
  attr_reader :user
  
  def initialize(u)
    @user = u
  end

  def show?
    @user && ActiveSessionTracker.new(@user).new_session?
  end
  
  def prediction
    return nil unless @user
    @prediction ||= @user.predictor.predict_now
  end
  
  def stop
    @stop ||= TransitStop.create_with(name: prediction).find_or_create_by(stop_id: prediction)
  end
  
end