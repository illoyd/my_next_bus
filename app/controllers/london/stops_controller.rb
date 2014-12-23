class London::StopsController < ApplicationController
  
  City = 'london'
  
  after_action :record_stop_request, only: [:show]
  
  respond_to :html
  
  def index
    # Redirect to stop view if requested
    redirect_to london_stop_url(params[:stop]) if params[:stop].present?
    
    if signed_in?
      predicted_stop_sid = current_user.predictor.predict_now
      @predicted_stop = TransitStop.find_by(stop_sid: predicted_stop_sid) if predicted_stop_sid
    end

    # Otherwise just present form!
    flash[:info] = 'Try entering a stop number!' if !params[:stop].nil? && params[:stop].blank?
  end

  def show
    @statusboard = NotTfL::CachedBuses.new.stop(params[:id])
    @favorites   = signed_in? ? current_user.favorite_destinations.favorites.destinations : []
    
    if @statusboard.stop
      CreateOrUpdateStopJob.perform_later(City, @statusboard.stop)
    end
    
    rescue RestClient::RequestedRangeNotSatisfiable
      flash[:error] = "Sorry, we couldn't find a stop for #{ params[:id] }!"
      redirect_to london_stops_path
    
    rescue SocketError
      flash[:error] = "Sorry, we are unable to get predictions at this time. Please try again."
      redirect_to london_stops_path

  end
  
  def near
    @stops = if near_params[:lat].present? && near_params[:lon].present?
      NotTfL::CachedBuses.new.near(near_params[:lat], near_params[:lon])
    else
      []
    end

    # Sort stops by distance if available
    @stops.stops.sort_by! { |s| current_point.distance_between(s.point) } if current_point?

    respond_with @stops

    rescue RestClient::RequestedRangeNotSatisfiable
      flash[:error] = "Sorry, we couldn't find any nearby stops!"
      redirect_to london_stops_path
  end
  
  def favorite
    ToggleFavoriteStopJob.new.perform(current_user, City, params[:id]) if signed_in?
    redirect_to_back_or london_stop_path(params[:id])
  end
  
  protected
  
  def record_stop_request
    if current_user
      RecordStopRequestJob.perform_later(current_user, City, params[:id])
    end
  end
  
  def favorite_params
    params.permit(:id)
  end
  
  def near_params
    params.permit(:lat, :lon)
  end

end
