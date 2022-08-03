class TransactionsController < ApplicationController
  def authorize
    render json: Transactions::AuthorizeService.new(authorize_params).run, status: :ok
  end

  def charge
  end

  def refund
  end

  def reverse
  end

  private

  def authorize_params
    { customer_email: params['customer_email'], customer_phone: params['customer_phone'], amount: params['amount'], merchant_id: @current_user.id }
  end
end
