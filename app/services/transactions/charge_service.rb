# frozen_string_literal: true

module Transactions
  class ChargeService < BaseService
    def initialize(merchant_id:, amount:, uuid:)
      super
      @amount = amount
      @uuid = uuid
    end

    def run
      if valid_to_charge?
        Transaction::Charge.create!(parent_transaction: authorized_transaction, amount: amount)
      else
        Transaction::Charge.create!(amount: amount, status: :error)
      end
    end

    private

    def authorized_transaction
      @authorized_transaction ||= Transaction::Authorized.find(uuid)
    end

    def valid_to_charge?
      authorized_transaction&.approved?
    end
  end
end
