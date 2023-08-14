class AccountActivationsController < ApplicationController
  before_action :load_user, only: :edit

  def edit
    if !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t "flash.mail_activated_success"
      redirect_to @user
    else
      flash[:danger] = t "flash.mail_activated_fail"
      redirect_to root_url
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "flash.user_not_found"
    redirect_to root_url
  end
end
