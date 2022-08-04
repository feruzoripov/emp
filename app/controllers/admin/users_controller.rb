# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    before_action :set_user, only: %i[show destroy update]

    def index
      render json: User.active, status: :ok
    end

    def show
      render json: @user, status: :ok
    end

    def update
      @user.update!(user_params)
      render json: @user, status: :ok
    end

    def destroy
      render json: @user.destroy!, status: :ok
    end

    private

    def set_user
      @user ||= User.active.find(params['id'])
    end

    def user_params
      params.permit(:name, :email, :description, :status)
    end
  end
end
