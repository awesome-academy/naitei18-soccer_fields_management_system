class ApplicationController < ActionController::Base
  include SessionsHelper
  around_action :switch_locale
  rescue_from CanCan::AccessDenied, with: :cancan_access_denied

  private

  def switch_locale &action
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash.please_login"
    redirect_to login_url
  end

  def cancan_access_denied
    flash[:danger] = t "flash.not_authorized"
    redirect_to root_url
  end
end
