class London::StopsController < ApplicationController
  
  def index
    # Redirect to stop view if required
    redirect_to london_stop_url(params[:stop]) if params[:stop].present?
    
    # Otherwise just present form!
    flash[:info] = 'Try entering a stop number!' if !params[:stop].nil? && params[:stop].blank?
  end

  def show
    @statusboard = NotTfL::CachedBuses.new.stop(params[:id])
    
    rescue RestClient::RequestedRangeNotSatisfiable
      flash[:error] = "Sorry, we couldn't find a stop for #{ params[:id] }!"
      redirect_to london_stops_path
  end

end
