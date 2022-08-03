module Transactions
  class AuthorizeService < BaseService

    def initialize(customer_email:, customer_phone:, amount:, merchant_id:)
      super
      @customer_email = customer_email
      @customer_phone = customer_phone
      @amount = amount
    end

    def run
      Transaction::Authorize.create!(
        customer_email: customer_email,
        customer_phone: customer_phone,
        amount: amount,
        merchant: merchant
      )
    end
  end
end
