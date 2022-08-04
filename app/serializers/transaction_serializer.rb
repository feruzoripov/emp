class TransactionSerializer < ActiveModel::Serializer
  attributes :uuid, :type, :customer_email, :customer_phone, :status, :amount, :parent_transaction_uuid, :merchant_id

  def parent_transaction_uuid
    object.parent_transaction.uuid if object.parent_transaction.present?
  end

  def merchant_id
    object.user_id
  end
end
