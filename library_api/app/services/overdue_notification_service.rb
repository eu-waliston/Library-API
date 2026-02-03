# frozen_string_literal: true

class OverdueNotificationService
  def self.send_notifications
    overdue_loans = Loan.overdue.includes(:user, :book)

    overdue_loans.each do |loan|
      # Verifica se ja notificou hoje
      next if loan.user.notifications
                  .where(notifications_type: 'overdue_reminder')
                  .where('created_at > ?', 1.day.ago)
                  .exists?

      # Envia notificação
      loan.user.notification.create!(
        title: 'Overdue Book',
        message: "The Book: '#{loan.book.title}' is overdue by #{loan.days_overdue}.",
        notifications_type: 'overdue_reminder',
      )

      # Envia email (em background)
      OverdueNotificationMailer.reminder(loan).deliver_later
    end
  end
end

