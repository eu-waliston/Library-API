# frozen_string_literal: true
class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.bigint :user_id, null: false
      t.bigint :book_copy_id, null: false
      t.datetime :reserved_at, null: false
      t.datetime :expires_at, null: false
      t.datetime :fulfilled_at
      t.datetime :canceled_at
      t.timestamps
    end

    add_index :reservations, :user_id
    add_index :reservations, :book_copy_id
    add_index :reservations, :expires_at
    add_index :reservations, :canceled_at

    add_foreign_key :reservations, :users
    add_foreign_key :reservations, :book_copies
  end
end

