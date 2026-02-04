# frozen_string_literal: true

class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.bigint :user_id, null: false
      t.bigint :book_copy_id, null: false
      t.datetime :borrowed_at, null: false
      t.datetime :due_date, null: false
      t.datetime :returned_at
      t.timestamps
    end

    add_index :loans, :user_id
    add_index :loans, :book_copy_id
    add_index :loans, :due_date
    add_index :loans, :returned_at

    add_foreign_key :loans, :users
    add_foreign_key :loans, :book_copies
  end
end
