# frozen_string_literal: true

module Transactions
  class ReverseService < BaseService
    def initialize(merchant_id:, uuid:)
      super
      @uuid = uuid
    end

    def run
      transaction = Transaction::Reversal.new(merchant: merchant)

      if valid_to_reverse?
        transaction.parent_transaction = authorized_transaction
        transaction.customer_email = authorized_transaction.customer_email
        transaction.customer_phone = authorized_transaction.customer_phone
        authorized_transaction.reversed!
      else
        transaction.status = :error
      end

      transaction.save!

      transaction.reload.uuid
    end

    private

    def valid_to_reverse?
      authorized_transaction&.approved?
    end

    def authorized_transaction
      @authorized_transaction ||= Transaction::Authorize.find_by_uuid(uuid)
    end
  end
end
