# frozen_string_literal: true

class CreateLocationsAndBookCopies < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :section
      t.string :shelf
      t.timestamps
    end

    add_index :locations, :code, unique: true

    create_table :book_copies do |t|
      t.bigint :book_id, null: false
      t.string :barcode, null: false
      t.integer :status, default: 0, null: false
      t.date :acquisition_date, null: false
      t.bigint :location_id
      t.timestamps
    end

    add_index :book_copies, :barcode, unique: true
    add_index :book_copies, :book_id
    add_index :book_copies, :status
    add_index :book_copies, :location_id

    add_foreign_key :book_copies, :books
    add_foreign_key :book_copies, :locations
  end
end
