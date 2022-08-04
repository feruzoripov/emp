# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.uuid :uuid, default: 'gen_random_uuid()', null: false
      t.decimal :amount
      t.integer :status, default: 0
      t.string :customer_email
      t.string :customer_phone

      t.timestamps
    end
  end
end
