class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :require_login

  private

  def current_user
  	@current_user ||= User.find_by(uid: session[:user_id]) if session[:user_id]
  end
  
  def require_login
    session[:return_to] = request.fullpath
    redirect_to "/login"
  end

end
