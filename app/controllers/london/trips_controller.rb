class London::TripsController < ApplicationController
  
  City = 'london'
  
  after_action :record_trip_request, only: [:show]
  
  def show
    @statusboard = NotTfL::CachedBuses.new.trip(params[:id])
    
    raise RestClient::RequestedRangeNotSatisfiable unless @statusboard.predictions.any?

    rescue RestClient::RequestedRangeNotSatisfiable
      flash[:error] = "Sorry, we couldn't find a trip for #{ params[:id] }!"
      redirect_to :back
  end
  
  protected
  
  def record_trip_request
    if current_user
      RecordStopRequestJob.perform_later(current_user, City, params[:id])
    end
  end

end
