class UsersController < ApplicationController
    skip_before_action :require_user

    def new
        @user = User.new
    end

    def create
        # byebg
        @user = User.new(user_params)

        if @user.save
            flash[:success] = "Your have successfully signed up."
            redirect_to login_path
            else
            render 'new'
        end
    end

    private
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
