class Api::SessionsController < ApplicationController
  def show
    @user = current_user
    if @user
      render json: { user: current_user }
    else
      render json: { user: nil }
    end
  end

  def create
    @user = User.find_by_credentials(params[:credential], params[:password])
    if @user
      login!(@user)
      render json: { user: @user }
    else
      render json: { errors: ['Invalid credentials'], status: :unauthorized }
    end
  end

  def destroy
    @user = current_user
    if @user
      logout!
      render json: { message: 'success' }
    end
  end

  
end
