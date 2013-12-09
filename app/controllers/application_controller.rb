class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :require_login


  #continue to use rescue_from in the same way as before
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found   
    rescue_from ActionController::RoutingError, :with => :render_not_found
  end 
 
  #called by last route matching unmatched routes.  Raises RoutingError which will be rescued from in the same way as other exceptions.
  def raise_not_found!
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end
 
  #render 500 error 
  def render_error(e)
    respond_to do |f| 
      f.html{ render :template => "errors/server_error", :status => 500 }
    end
  end
  
  #render 404 error 
  def render_not_found(e)
    respond_to do |f| 
      f.html{ render :template => "errors/not_found", :status => 404 }
    end
  end

  private

  def current_user
  	@current_user ||= User.find_by(uid: session[:user_id]) if session[:user_id]
  end
  
  def require_login
    session[:return_to] = request.fullpath
    redirect_to "/login"
  end
    
end
