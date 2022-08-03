class Transaction < ApplicationRecord
  validates :customer_email, presence: true
  validates :customer_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :type, presence: true

  belongs_to :user

  has_one :child_transaction, class_name: 'Transaction', foreign_key: 'parent_transaction_id'

  belongs_to :parent_transaction, class_name: 'Transaction', optional: true

  enum status: {
    approved: 0,
    reversed: 1,
    refunded: 2,
    error: 3
  }
end
