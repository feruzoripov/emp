class TransactionService
  attr_accessor :customer_email, :customer_phone, :amount, :uuid

  def initialize(customer_email:, customer_phone:, amount:, uuid:)
    @customer_email = customer_email
    @customer_phone = customer_phone
    @amount = amount
    @status = status
    @uuid = uuid
  end

  def authorize
    transaction = Transaction::Authorize.new(customer_email: customer_email, customer_phone: customer_phone, amount: amount)
    transaction.save!
  end

  def charge
    authorized_transaction = Transaction::Authorized.find(uuid)
    if authorized_transaction && authorized_transaction.approved?
      charge_transaction = Transaction::Charge.new(parent_transaction: authorized_transaction, amount: amount)
      charge_transaction.save!
    else
      charge_transaction = Transaction::Charge.new(amount: amount, status: :error)
      charge_transaction.save!
    end
  end

  def refund
    charged_transaction = Transaction::Charged.find(uuid)
    if charged_transaction && charged_transaction.approved?
      refund_transaction = Transaction::Refund.new(parent_transaction: charged_transaction, amount: amount)
      refund_transaction.save!
      charged_transaction.update_attributes(status: :refunded)
    else
      refund_transaction = Transaction::Refund.new(amount: amount, status: :error)
      refund_transaction.save!
    end
  end

  def reverse
    authorized_transaction = Transaction::Authorized.find(uuid)
    if authorized_transaction && authorized_transaction.approved?
      reversal_transaction = Transaction::Reversal.new(parent_transaction: authorized_transaction)
      reversal_transaction.save!
      authorized_transaction.update_attributes(status: :reversed)
    else
      reversal_transaction = Transaction::Charge.new(status: :error)
      reversal_transaction.save!
    end
  end
end
