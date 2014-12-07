class London::DestinationsController < London::Controller
  
  def favorite
    ToggleFavoriteDestinationJob.new.perform(current_user, City, favorite_params[:id]) if signed_in?
    redirect_to_back_or london_stops_url
  end
  
  protected
  
  def favorite_params
    params.permit(:id)
  end

end
