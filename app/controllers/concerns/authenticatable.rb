module Authenticatable
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_user!, only: [:new, :create]
  end

  def new
    build_sign_in
  end

  def create
    build_sign_in
    save_sign_in or render 'new'
  end

  def destroy
    sign_out
  end

  private

  def build_sign_in
    @sign_in ||= User::LoginForm.new(sign_in_params)
  end

  def sign_in_params
    user_params = params[:user_login_form]
    user_params ? user_params.permit(:username, :password) : {}
  end

  def save_sign_in
    if @sign_in.save
      @sign_in.user.update_tracked_fields!(request)
      session[:user_id] = @sign_in.user.id
      redirect_to_url
    end
  end

  def sign_out
    session[:user_id] = nil
    @current_user = nil
    redirect_to_url
  end

  def redirect_to_url
    raise NotImplementedError, 'Must be implemented by who mixins me.'
  end

end