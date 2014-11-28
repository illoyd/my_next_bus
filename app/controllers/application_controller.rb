class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  
  before_action :predict_stop

  after_action :record_visit

  def new_session_path(scope)
    new_user_session_path
  end
  
  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup' || (controller_name == 'users' && action_name == 'update') || (controller_name == 'sessions' && action_name == 'destroy')

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end
  
  def predict_stop
    if signed_in? && ActiveSessionTracker.new(current_user).new_session?
      record_visit
      redirect_to london_stop_path(current_user.predictor.predict_now)
    end
  end
  
  def record_visit
    if signed_in?
      ActiveSessionTracker.new(current_user).record_visit
    end
  end

end
