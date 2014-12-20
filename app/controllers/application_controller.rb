class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  
  before_action :assign_stop_suggester

  after_action :record_visit

  def can_redirect_back?
    request.env["HTTP_REFERER"].present?
  end
  
  def redirect_to_back_or(path)
    redirect_to can_redirect_back? ? :back : path
  end
  
  def new_session_path(scope)
    new_user_session_path
  end
  
  protected

  ##
  # Redirect to the requested page after signing in
  def after_sign_in_path_for(resource)
    session["user_return_to"] || root_path
  end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup' || (controller_name == 'users' && action_name == 'update') || (controller_name == 'sessions' && action_name == 'destroy')
      
    # Break if pending a confirmation
    return if current_user.try(:pending_any_confirmation)

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end
  
  def assign_stop_suggester
    @stop_suggester = StopSuggester.new(current_user)
  end
  
  def record_visit
    if signed_in?
      ActiveSessionTracker.new(current_user).record_visit
    end
  end

end
