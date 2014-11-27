class London::StopsController < ApplicationController
  
  after_action :record_visit
  after_action :record_stop_request, only: [:show]
  
  def index
    # Redirect to stop view if required
    redirect_to london_stop_url(params[:stop]) if params[:stop].present?
    
    # Otherwise just present form!
    flash[:info] = 'Try entering a stop number!' if !params[:stop].nil? && params[:stop].blank?
  end

  def show
    @statusboard = NotTfL::CachedBuses.new.stop(params[:id])
    
    if @statusboard.predictions?
      SaveStopNameJob.perform_later('london', params[:id], @statusboard.stop_name)
    end
    
    rescue RestClient::RequestedRangeNotSatisfiable
      flash[:error] = "Sorry, we couldn't find a stop for #{ params[:id] }!"
      redirect_to london_stops_path
  end
  
  protected
  
  def record_visit
    if current_user
      ActiveSessionTracker.new(current_user).record_visit
    end
  end

  def record_stop_request
    if current_user
      current_user.stop_requests.create(stop_id: params[:id])
    end
  end

end
