class UserController < ApplicationController
	respond_to :xml, :json, :html

	def index		#GET /user
		@user = User.all
		respond_with(@user)
	end

  def login
    #Empty controller method
  end

  def profile
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
      @recipes = Recipe.where("users_id = ?", @user.id)
    end
  end

	def create	#POST /user
		@user = User.new(user_params)

		if @user.save
			redirect_to @user
		else
			render "new"
		end
	end

	def new			#GET /user/new
		@user = User.new
	end
	
	def edit		#GET /user/:id/edit
		@user = User.find(params[:id])
	end
	
	def show		#GET /user/:id
		@user = User.find(params[:id])
	end
	
	def update 	#PUT/PATCH /user/:id
		@user = User.find(params[:id])

		if @user.update(user_params)
			redirect_to @user
		else
			render "edit"
		end
	end

	def destroy #DELETE /user/:id
		@user = User.find(params[:id])
		@user.destroy

		redirect_to user_index_path
	end


	private
		def user_params
			params.require(:user).permit(:name)
		end

end
