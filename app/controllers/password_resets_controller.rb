class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(create edit update)
  before_action :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t "flash.sent_reset_password_email"
    redirect_to root_url
  end

  def edit; end

  def update
    if user_params[:password].blank?
      @user.error.add :password, t("error")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "flash.reset_password_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def load_user
    @user = User.find_by email: (params.dig(:password_reset, :email) ||
                                params[:email])&.downcase

    return if @user

    flash[:danger] = t "flash.email_not_found"
    render :new
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "flash.user_in_actived"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "flash.reset_password_expired"
    redirect_to new_password_reset_url
  end
end
