class ProfileController < ApplicationController
  def index
    
  end

  def show
    #Empty controller method
    if params[:id].blank? #use current_user if there is no id in url 
      if current_user #If there is noone logged in, force login
        @user = current_user
      else
        require_login
      end
    else #Find user profile if there is a id
      @user = User.find(params[:id])
    end
    unless @user.blank? #Only find recipes if there is a user
      @recipes = @user.recipes
      @favorites = @user.favorites
    end
  end

  def update
    @user = current_user
    if @user.update_attributes(:name => params[:user][:first_name] + " " + params[:user][:last_name], :given_name => params[:user][:first_name], :family_name => params[:user][:last_name], :gender => params[:user][:gender])
      respond_to do |format|
        format.js
      end
    else
      redirect_to "/profile"
    end
  end
end
