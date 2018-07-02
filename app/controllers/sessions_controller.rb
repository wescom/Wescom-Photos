class SessionsController < ApplicationController
	def new
		redirect_to root_path if current_user
	end

	def create
		ldap_user = Adauth.authenticate(params[:username], params[:password])
		Rails.logger.info "username: "+params[:username].to_s
		Rails.logger.info "ldap_user: "+ldap_user.to_s
		if ldap_user
        	user = User.return_and_create_from_adauth(ldap_user)
        	session[:user_id] = user.id
        	redirect_to root_path
    	else
          flash_message :notice, "Login failed"
        	redirect_to login_path, :error => "Invalid Login"
        	Rails.logger.info "*** Invalid Login ***"
    	end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path
	end
end