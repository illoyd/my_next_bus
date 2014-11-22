class London::StopsController < ApplicationController
  
  def index
    # Redirect to stop view if required
    redirect_to london_stop_url(params[:stop]) if params[:stop]
    
    # Otherwise just present form!
  end

  def show
    @statusboard = NotTfL::CachedBuses.new.stop(params[:id])
  end

end
