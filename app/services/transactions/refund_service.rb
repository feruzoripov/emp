# frozen_string_literal: true

module Transactions
  class RefundService < BaseService
    def initialize(merchant_id:, amount:, uuid:)
      super
      @amount = amount
      @uuid = uuid
    end

    def run
      transaction = Transaction::Refund.new(amount: amount, merchant: merchant)

      if valid_to_refund?
        transaction.parent_transaction = charged_transaction
        transaction.customer_email = charged_transaction.customer_email
        transaction.customer_phone = charged_transaction.customer_phone
        update_merchant_total_transaction_sum
      else
        transaction.status = :error
      end

      transaction.save!
      charged_transaction.refunded!

      transaction.reload.uuid
    end

    private

    def charged_transaction
      @charged_transaction ||= Transaction::Charge.find_by_uuid(uuid)
    end

    def valid_to_refund?
      charged_transaction&.approved?
    end

    def update_merchant_total_transaction_sum
      merchant.total_transaction_sum -= amount
      merchant.save
    end
  end
end
