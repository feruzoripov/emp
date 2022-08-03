# frozen_string_literal: true

class Transaction < ApplicationRecord
  validates :status, presence: true
  validates :type, presence: true
  validates :customer_email, presence: true, unless: :not_error
  validates :customer_email, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: :not_error

  belongs_to :merchant, class_name: 'User', foreign_key: 'user_id'

  has_one :child_transaction, class_name: 'Transaction', foreign_key: 'parent_transaction_id'

  belongs_to :parent_transaction, class_name: 'Transaction', optional: true

  enum status: {
    approved: 0,
    reversed: 1,
    refunded: 2,
    error: 3
  }

  private

  def not_error
    error?
  end
end
