# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  enum status: {
    active: 0,
    inactive: 1
  }

  has_many :transactions

  before_destroy :check_for_transactions

  private

  def check_for_transactions
    return if transactions.size.zero?

    errors[:base] << 'there are related payments'
    throw :abort
  end
end
