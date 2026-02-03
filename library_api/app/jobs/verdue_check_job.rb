# frozen_string_literal: true

class OverdueCheckJob < ApplicationJob
  queue_as :default

  def perform
    # Verifica empréstimos atrasados
    OverdueNotificationService.send_notifications

    # Calcula multas
    calculate_overdue_fines

    # Atualzia estatisticas
    update_book_statistics
  end

  private

  def calculate_overdue_fines
    Loan.overdue.find_each do |loan|
      next if loan.fine.present?

      fine_amount = loan.calculate_fine
      if fine_amount > 0
        loan.create_fine!(
          amout: fine_amount,
          status: 'pending',
          due_date: 30.days.from_now
        )
      end
    end
  end

  def update_book_statistics
    Book.find_each do |book|
      book.update_statistics
    end
  end
end
