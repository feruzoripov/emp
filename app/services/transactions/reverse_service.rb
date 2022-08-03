module Transactions
  class ReverseService < BaseService

    def initialize(merchant_id:, uuid:)
      super
      @uuid = uuid
    end

    def run
      if valid_to_reverse?
        Transaction::Reversal.create!(parent_transaction: authorized_transaction)
        authorized_transaction.reversed!
      else
        Transaction::Charge.create!(status: :error)
      end
    end

    private

    def valid_to_reverse?
      authorized_transaction && authorized_transaction.approved?
    end

    def authorized_transaction
      @authorized_transaction ||= Transaction::Authorized.find(uuid)
    end
  end
end
