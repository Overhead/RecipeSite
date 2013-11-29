class UserController < ApplicationController
	respond_to :xml, :json, :html

	def index		#GET /user
		@user = User.all
		respond_with(@user)
	end

  def login
    #Empty controller method
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
