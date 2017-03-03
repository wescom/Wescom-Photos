class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
    include ApplicationHelper
    helper_method :current_user

    def require_user
      unless current_user
        redirect_to '/login', :error => "Invalid Login"
        return false
      end
    end

  helper_method :current_user, :signed_in?

  private
  def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def authenticate_user!
     if current_user.nil?
         redirect_to '/login', :error => "Invalid Login" 
     end
  end

  def signed_in?
    !!current_user
  end
  
  def require_admin
    unless admin?
      redirect_to '/search'
      return false
    end
  end
end
