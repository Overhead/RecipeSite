class UserController < ApplicationController
	respond_to :xml, :json, :html
	def index
		@user = User.all
		respond_with(@user)
	end
end
