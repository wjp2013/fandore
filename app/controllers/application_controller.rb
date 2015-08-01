class ApplicationController < ActionController::Base
  # gem pundit config
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  before_action :authenticate_user!

  private

  def authenticate_user!
    redirect_to sign_in_path unless current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue
    session[:user_id] = nil
  end

  helper_method :current_user
end
