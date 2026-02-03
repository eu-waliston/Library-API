# app/services/overdue_notification_service.rb
class OverdueNotificationService
  def self.send_notifications
    overdue_loans = Loan.overdue.includes(:user, :book)

    overdue_loans.each do |loan|
      # Verifica se já notificou hoje
      next if loan.user.notifications
                  .where(notification_type: 'overdue_reminder')
                  .where('created_at >= ?', 1.day.ago)
                  .exists?

      # Envia notificação
      loan.user.notifications.create!(
        title: 'Overdue Book',
        message: "The book '#{loan.book.title}' is overdue by #{loan.days_overdue} days.",
        notification_type: 'overdue_reminder'
      )

      # Envia email (em background)
      OverdueNotificationMailer.reminder(loan).deliver_later
    end
  end
end