# frozen_string_literal: true

class OverdueNotificationMailer < ApplicationMailer
  default from 'noreply@library.com'

  def reminder(loan)
    @loan = loan
    @user = loan.user
    @days_overdue = loan.days_overdue
    @fine_amount = loan.calculate_fine

    mail(
      to: @user.email,
      subject: "Overdue Book Reminder: #{loan.book.title}"
    )
  end
end

