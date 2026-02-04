# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :isbn, null: false
      t.text :description
      t.integer :publication_year
      t.integer :pages
      t.string :language
      t.string :genre
      t.string :cover_image
      t.bigint :author_id
      t.bigint :category_id
      t.bigint :publisher_id
      t.decimal :average_rating, precision: 3, scale: 2, default: 0.0
      t.integer :total_reviews, default: 0
      t.timestamps
    end

    add_index :books, :isbn, unique: true
    add_index :books, :title
    add_index :books, :author_id
    add_index :books, :category_id
    add_index :books, :publisher_id

    add_foreign_key :books, :authors
    add_foreign_key :books, :categories
    add_foreign_key :books, :publishers
  end
end