module Transactions
  class BaseService
    attr_accessor :merchant_id, :uuid, :amount, :customer_email, :customer_phone,

    def initialize(merchant_id:, **args)
      @merchant_id = merchant_id
    end

    def run
    end

    private

    def merchant
      @merchant ||= User.active.find(merchant_id)
    end
  end
end
