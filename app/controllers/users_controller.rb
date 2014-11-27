class UsersController < ApplicationController
  # before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]
  load_and_authorize_resource
  respond_to :html

  # GET /users/:id.:format
  def show
    respond_with @user
  end

  # GET /users/:id/edit
  def edit
    respond_with @user
  end

  # PATCH/PUT /users/:id.:format
  def update
    flash[:success] = 'Hooray! We\'ve saved your edits.' if @user.update(user_params)
    respond_with @user
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user 
    if request.patch? && params[:user] && params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        flash[:success] = 'Hooray! We\'ve saved your edits.'
        respond_with @user
      else
        @show_errors = true
      end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    def user_params
      accessible = [ :name, :email ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
