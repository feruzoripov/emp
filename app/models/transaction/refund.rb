# frozen_string_literal: true

class Transaction::Refund < Transaction
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
