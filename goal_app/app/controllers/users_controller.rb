class UsersController < ApplicationController
    before_action :require_no_user!
    def new
       @user = User.new
       render :new 
    end

    def create
        @user = User.new(user_params)
        if @user.save
            login_user!(@user)
            redirect_to user_url
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end


    def user_params
        params.require(:User).permit(:email, :password, :session_token)
    end
end 