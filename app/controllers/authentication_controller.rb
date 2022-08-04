# frozen_string_literal: true

class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login
  before_action :set_user, only: :login

  def login
    if @user&.authenticate(params[:password])
      render json: { token: token(@user.id), exp: time.strftime('%m-%d-%Y %H:%M'), name: @user.name }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def set_user
    @user ||= User.active.find_by_email(params[:email])
  end

  def token(user_id)
    JwtService.encode(user_id: user_id)
  end

  def time
    Time.now + 24.hours.to_i
  end

  def login_params
    params.permit(:email, :password)
  end
end
