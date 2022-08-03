class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.uuid :uuid, default: "gen_random_uuid()",null: false
      t.decimal :amount, default: 0
      t.integer :status, default: 0
      t.string :customer_email, null: false
      t.string :customer_phone

      t.timestamps
    end
  end
end
