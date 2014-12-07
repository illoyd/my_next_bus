class London::TripsController < London::Controller
  
  after_action :record_trip_request, only: [:show]
  
  def show
    @statusboard = NotTfL::CachedBuses.new.trip(params[:id])
    
    raise RestClient::RequestedRangeNotSatisfiable unless @statusboard.predictions.any?
    
    rescue RestClient::RequestedRangeNotSatisfiable
      flash[:error] = "Sorry, we couldn't find information for that trip! The trip has most likely concluded."
      redirect_to_back_or london_stops_path
  end
  
  def favorite
    if signed_in? && favorite_params[:stop_sid].present?
      ToggleFavoriteStopJob.new.perform(current_user, City, favorite_params[:stop_sid])
    end
    
    if favorite_params[:id].present?
      redirect_to london_trip_url(favorite_params[:id])
    else
      redirect_to london_stops_url
    end
  end
  
  protected
  
  def record_trip_request
    if current_user
      RecordTripRequestJob.perform_later(current_user, City, params[:id])
    end
  end

  def favorite_params
    params.permit(:id, :stop_sid)
  end

end