class LoginsController < ApplicationController
    skip_before_action :require_user, only: [:new, :create]

    def new
    end

    def create
        user = User.find_by(email: params[:email].downcase)
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            flash[:success] = "Your have successfully logged in."
            redirect_to products_path
        else
            flash[:warning] = "Either your email or password is incorrect."
            render 'new'
        end
    end

    def destroy
        session[:user_id] = nil
        flash[:success] = "Your have successfully logged out."
        redirect_to products_path
    end
end
