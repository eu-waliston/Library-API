# frozen_string_literal: true

class Fine < AplicationRecord
  belongs_to  :user
  belongs_to  :loan

  enum status:  {pending: 0, paid: 1, waived: 2, overdue: 3}

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :due_date, presence: true

  before_validation :set_default_due_date

  scope :overdue, -> { where('due_date < ?', Date.current).where(status: pending)}

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :due_date, presence: true

  before_validation :set_default_date

  scope :overdue, -> { where('due_date < ?', Date.current).where(status: pending)}

  scope :pending, -> { where(status: :pending)}

  def overdue?
    due_date < Date.current && pending?
  end

  def pay(payment_method = 'credit_card')
    return false if paid? || waived?

    transaction do
      update!(status: :paid, paid_at: Time.current, payment_method: payment_method)
      create_notification
    end
  end

  def waive(reason)
    return false if paid?

    transaction do
      update!(status: :waived, waived_at: Time.current, waiver_reason:reason)
      create_notification
    end
  end

  private

  def set_default_due_date
    self.due_date ||= 30.days.from_now.to_date
  end

  def create_notification
    user.notifications.create!(
      title: "Fine #{status}",
      message: "Fine of $#{amount} has been #{status}",
      notification_type: "fine_#{status}"
    )
  end
end
