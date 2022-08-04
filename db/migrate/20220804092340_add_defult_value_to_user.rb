# frozen_string_literal: true

class AddDefultValueToUser < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :total_transaction_sum, 0
  end
end
