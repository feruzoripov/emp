# frozen_string_literal: true

class Transaction::Charge < Transaction
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
