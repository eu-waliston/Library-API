# frozen_string_literal: true

class CreateFines < ActiveRecord::Migration[7.0]
  def change
    create_table :fines do |t|
      t.bigint :user_id, null: false
      t.bigint :loan_id, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :status, default: 0, null: false
      t.date :due_date, null: false
      t.datetime :paid_at
      t.datetime :waived_at
      t.string :payment_method
      t.text :waiver_reason
      t.timestamps
    end

    add_index :fines, :user_id
    add_index :fines, :loan_id
    add_index :fines, :status

    add_foreign_key :fines, :users
    add_foreign_key :fines, :loans
  end
end
