module Transactions
	class RefundService < BaseService

		def initialize(merchant_id:, amount:, uuid:)
			super
			@amount = amount
			@uuid = uuid
		end

		def run
			if valid_to_refund?
				Transaction::Refund.create!(parent_transaction: charged_transaction, amount: amount)
				charged_transaction.refunded!
			else
				Transaction::Refund.create!(amount: amount, status: :error)
			end
		end

		private

		def charged_transaction
			@charged_transaction ||= Transaction::Charged.find(uuid)
		end

		def valid_to_refund?
			charged_transaction && charged_transaction.approved?
		end
	end
end
