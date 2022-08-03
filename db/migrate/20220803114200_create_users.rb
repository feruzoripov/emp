class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.text :description
      t.string :email, null: false
      t.integer :status, default: 0
      t.decimal :total_transaction_sum, defualt: 0
      t.string :password_digest

      t.timestamps
    end
  end
end
