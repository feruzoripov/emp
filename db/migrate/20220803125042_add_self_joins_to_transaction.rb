# frozen_string_literal: true

class AddSelfJoinsToTransaction < ActiveRecord::Migration[6.1]
  def change
    add_reference :transactions, :parent_transaction, foreign_key: { to_table: :transactions }
  end
end
