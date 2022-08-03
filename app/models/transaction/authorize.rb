# frozen_string_literal: true

class Transaction::Authorize < Transaction
  validates :customer_email, presence: true
  validates :customer_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
