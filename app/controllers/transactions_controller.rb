# frozen_string_literal: true

class TransactionsController < ApplicationController
  def authorize
    render json: Transactions::AuthorizeService.new(authorize_params).run, status: :ok
  end

  def charge
    render json: Transactions::ChargeService.new(charge_params).run, status: :ok
  end

  def refund
    render json: Transactions::RefundService.new(refund_params).run, status: :ok
  end

  def reverse
    render json: Transactions::ReverseService.new(reverse_params).run, status: :ok
  end

  private

  def authorize_params
    { customer_email: params['customer_email'], customer_phone: params['customer_phone'], amount: params['amount'],
      merchant_id: @current_user.id }
  end

  def charge_params
    { uuid: params['uuid'], amount: params['amount'], merchant_id: @current_user.id }
  end

  def refund_params
    { uuid: params['uuid'], amount: params['amount'], merchant_id: @current_user.id }
  end

  def reverse_params
    { uuid: params['uuid'], merchant_id: @current_user.id }
  end
end
