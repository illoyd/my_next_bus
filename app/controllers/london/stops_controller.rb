class London::StopsController < ApplicationController
  
  City = 'london'
  
  after_action :record_stop_request, only: [:show]
  
  respond_to :html
  
  def index
    # Get search forms
    @form = StopsForm.new(stops_form_params)

    # Redirect to stop view if requested
    redirect_to london_stop_url(@form.stop) if @form.stop.present?
    
    if signed_in?
      predicted_stop_id = current_user.predictor.predict_now
      @predicted_stop = TransitStop.find_by(stop_id: predicted_stop_id) if predicted_stop_id
      @form.predicted_stop_sid = predicted_stop_id
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
  end
  
  def near
    @stops = if near_params[:lat].present? && near_params[:lon].present?
      NotTfL::CachedBuses.new.near(near_params[:lat], near_params[:lon])
    else
      []
    end
    
    respond_with @stops
  end
  
  def favorite
#     if signed_in? && favorite_params[:destination].present?
#       ToggleFavoriteDestinationJob.new.perform(current_user, City, favorite_params[:destination])
#     end

    ToggleFavoriteStopJob.new.perform(current_user, City, params[:id]) if signed_in?
    redirect_to_back_or london_stop_path(params[:id])
    
#     if favorite_params[:id].present?
#       redirect_to london_stop_url(favorite_params[:id])
#     else
#       redirect_to london_stops_url
#     end
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
  
  def stops_form_params
    params.permit(:stops_form).permit(:stop, :lat, :lon)
  end
  
  def near_params
    params.permit(:lat, :lon)
  end

end
