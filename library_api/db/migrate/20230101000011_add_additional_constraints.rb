# frozen_string_literal: true

class AddAdditionalConstraints < ActiveRecord::Migration[7.0]
  def change
    # Check constraints para validar dados
    execute <<-SQL
      ALTER TABLE books
      ADD CONSTRAINT check_publication_year 
      CHECK (publication_year BETWEEN 1000 AND EXTRACT(YEAR FROM CURRENT_DATE));
      
      ALTER TABLE books
      ADD CONSTRAINT check_pages 
      CHECK (pages > 0);
      
      ALTER TABLE reviews
      ADD CONSTRAINT check_rating_range 
      CHECK (rating BETWEEN 1 AND 5);
      
      ALTER TABLE loans
      ADD CONSTRAINT check_due_date_after_borrowed 
      CHECK (due_date > borrowed_at);
      
      ALTER TABLE fines
      ADD CONSTRAINT check_positive_amount 
      CHECK (amount >= 0);
    SQL

    # Adicionar default para timestamps se necessário
    change_column_default :loans, :borrowed_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_default :reservations, :reserved_at, -> { 'CURRENT_TIMESTAMP' }
  end
end