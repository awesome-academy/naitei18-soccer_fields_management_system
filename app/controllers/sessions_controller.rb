class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase

    if user&.authenticate params[:session][:password]
      handle_activation user
    else
      flash.now[:danger] = t "flash.invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def handle_activation user
    if user.activated?
      log_in user
      handle_remember user
      redirect_back_or user
    else
      flash[:warning] = t "flash.not_activated"
      redirect_to root_path
    end
  end
end
