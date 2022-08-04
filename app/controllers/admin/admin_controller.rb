module Admin
  class AdminController < ApplicationController
    before_action :check_admin_role

    private

    def check_admin_role
      return if @current_user.admin?

      render json: { errors: 'not admin user' }, status: :unauthorized
    end
  end
end
