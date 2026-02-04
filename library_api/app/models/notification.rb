# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to  :user

  enum notification_type: {
    loan_created: 0,
    loan_overdue: 1,
    loan_returned: 2,
    reservation_available: 3,
    fine_created: 4,
    fine_paid: 5,
    fine_overdue: 6,
    system_announcement: 7
  }

  validates :title, presence: true, lenght: { maximum: 200 }
  validates :message, presence: true, length: { maximum: 1000 }

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, -> (type) { where(notification_type: type) }

  def mark_as_read
    update!(read_at: Time.current) unless read?
  end

  def readonly?
    read_at.present?
  end
end
