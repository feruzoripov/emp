module Admin
  class TransactionsController < AdminController
    def authorize
      render json: Transaction::Authorize.all, status: :ok
    end

    def charge
      render json: Transaction::Charge.all, status: :ok
    end

    def refund
      render json: Transaction::Refund.all, status: :ok
    end

    def reversal
      render json: Transaction::Reversal.all, status: :ok
    end

    def show
      render json: find_transaction, status: :ok
    end

    private

    def find_transaction
      Transaction.find_by_uuid(params['uuid'])
    end
  end
end
