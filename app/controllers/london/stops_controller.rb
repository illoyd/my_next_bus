class London::StopsController < ApplicationController
  
  City = 'london'
  
  after_action :record_stop_request, only: [:show]
  
  def index
    # Redirect to stop view if required
    redirect_to london_stop_url(params[:stop]) if params[:stop].present?
    
    if signed_in?
      predicted_stop_id = current_user.predictor.predict_now
      @predicted_stop = TransitStop.find_by(stop_id: predicted_stop_id) if predicted_stop_id
    end
    
    # Otherwise just present form!
    flash[:info] = 'Try entering a stop number!' if !params[:stop].nil? && params[:stop].blank?
  end

  def show
    @statusboard = NotTfL::CachedBuses.new.stop(params[:id])
    @favorites   = signed_in? ? current_user.favorites_for(City, params[:id]) : []
    
    if @statusboard.stop
      CreateOrUpdateStopJob.perform_later(City, @statusboard.stop)
    end
    
    rescue RestClient::RequestedRangeNotSatisfiable
      flash[:error] = "Sorry, we couldn't find a stop for #{ params[:id] }!"
      redirect_to london_stops_path
  end
  
  def favorite
    if signed_in? && params[:id].present? && params[:destination].present?
      favorite = current_user.favorite_destinations.find_or_create_by(city: City, stop_sid: params[:id], destination: params[:destination])
      favorite.toggle!(:favorite)
    end
    
    if params[:id].present?
      redirect_to london_stop_url(params[:id])
    else
      redirect_to london_stops_url
    end
  end
  
  protected
  
  def record_stop_request
    if current_user
      RecordStopRequestJob.perform_later(current_user, City, params[:id])
    end
  end

end
