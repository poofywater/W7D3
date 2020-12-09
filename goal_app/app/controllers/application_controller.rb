class ApplicationController < ActionController::Base
# L L L

    helper_method :current_user, logged_in?
    protection_from_forgery with: :exception

    def require_no_user!                             #R
        redirect_to user_url if current_user 
    end

    def current_user                                           #C
        return nil unless session[:session_token] 
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def ensure_logged_in!                                 #E
        redirect_to new_session_url if current_user.nil?
    end

    def logged_in?                               #l
        !!current_user
    end

    def logout_user!
        current_user.reset_session_token!
        session[:session_token] = nil
    end

    def login_user!(user)         #l
        session[:session_token] = user.reset_session_token!
    end
    
end
