class Frontend::Users::SessionsController < Frontend::ApplicationController
  # before_filter :authenticate_user!, only: [:destroy]

  def new
    build_sign_in
  end

  def create
    build_sign_in
    save_sign_in or render 'new'
  end

  def destroy
    sign_out
    redirect_to root_path
  end

private

  def build_sign_in
    @sign_in ||= User::LoginForm.new(sign_in_params)
  end

  def save_sign_in
    if @sign_in.save
      session[:current_user_id] = @sign_in.user.id
      redirect_to root_path
    end
  end

  def sign_in_params
    user_params = params[:sign_in]
    user_params ? user_params.permit(:username, :password) : {}
  end

end
