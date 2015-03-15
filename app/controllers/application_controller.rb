class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_signup_complete, only: [:new, :create, :update, :destroy]
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
  
  def current_point
    if params[:lat].present? && params[:lon].present?
      @current_point ||= NotTfL::Point.new(params[:lat], params[:lon])
    else
      @current_point = nil
    end
  end
  
  def current_point?
    current_point.present?
  end
  
  helper_method :current_point, :current_point?

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end
  
  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end
  
  helper_method :current_or_guest_user, :guest_user

  protected

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    current_user.absorb_from(guest_user)
  end

  def create_guest_user
    User.new(name: "guest", email: "guest_#{Time.now.to_i}#{rand(100)}@example.com", guest: true).tap do |u|
      u.skip_confirmation!
      u.save!(validate: false)
      session[:guest_user_id] = u.id
    end
  end
  
  ##
  # Redirect to the requested page after signing in
  def after_sign_in_path_for(resource)
    session["user_return_to"] || root_path
  end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup' || (controller_name == 'users' && action_name == 'update') || (controller_name == 'sessions' && action_name == 'destroy')
      
    # Break if a guest user
    # Break if pending a confirmation
    return if current_user.try(:guest?) || current_user.try(:pending_any_confirmation)

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end
  
  def record_visit
    ActiveSessionTracker.new(current_or_guest_user).record_visit
  end
  
end
