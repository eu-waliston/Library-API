# frozen_string_literal: true

class AddPerformanceIndexes < ActiveRecord::Migration[7.0]
  def change
    # Índices compostos para consultas comuns
    add_index :books, [:genre, :average_rating]
    add_index :books, [:publication_year, :average_rating]

    # Índices para consultas de status
    add_index :book_copies, [:book_id, :status]
    add_index :loans, [:user_id, :returned_at]
    add_index :loans, [:due_date, :returned_at]

    # Índices para consultas de data
    add_index :reviews, [:book_id, :created_at]
    add_index :notifications, [:user_id, :read_at, :created_at]

    # Índice para busca por nome de autor
    add_index :authors, "LOWER(name) varchar_pattern_ops"

    # Índice para busca por título de livro
    add_index :books, "LOWER(title) varchar_pattern_ops"
  end
end