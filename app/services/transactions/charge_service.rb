# frozen_string_literal: true

module Transactions
  class ChargeService < BaseService
    def initialize(merchant_id:, amount:, uuid:)
      super
      @amount = amount
      @uuid = uuid
    end

    def run
      transaction = Transaction::Charge.new(amount: amount, merchant: merchant)

      if valid_to_charge?
        transaction.parent_transaction = authorized_transaction
        transaction.customer_email = authorized_transaction.customer_email
        transaction.customer_phone = authorized_transaction.customer_phone
      else
        transaction.status = :error
      end
      transaction.save!

      transaction.reload.uuid
    end

    private

    def authorized_transaction
      @authorized_transaction ||= Transaction::Authorize.find_by_uuid(uuid)
    end

    def valid_to_charge?
      authorized_transaction&.approved?
    end
  end
end
