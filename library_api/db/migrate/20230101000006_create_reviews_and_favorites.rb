# frozen_string_literal: true

class CreateReviewsAndFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.bigint :user_id, null: false
      t.bigint :book_id, null: false
      t.integer :rating, null: false
      t.text :comment
      t.timestamps
    end

    add_index :reviews, :user_id
    add_index :reviews, :book_id
    add_index :reviews, [:user_id, :book_id], unique: true

    create_table :favorites do |t|
      t.bigint :user_id, null: false
      t.bigint :book_id, null: false
      t.timestamps
    end

    add_index :favorites, :user_id
    add_index :favorites, :book_id
    add_index :favorites, [:user_id, :book_id], unique: true

    add_foreign_key :reviews, :users
    add_foreign_key :reviews, :books
    add_foreign_key :favorites, :users
    add_foreign_key :favorites, :books
  end
end
