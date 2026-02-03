# frozen_string_literal: true

class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book_copy
  has_one :book, through: :book_copy
  has_one :fine, dependent: :destroy

  validates :borrowed_at, presence: true
  validates :due_date, presence: true
  validate :due_date_after_borrowed

  scope :active, -> { where(returned_at: nil) }
  scope :overdue, -> { active.where('due_date < ?', Date.current) }
  scope :returned, -> { where.not(returned_at: nil) }

  after_create :create_notification
  after_update :check_fine, if: :returned_at_changed?

  def overdue?
    due_date < Date.current && returned_at.nil?
  end

  def days_overdue
    return 0 unless overdue?
    (Date.current - due_date).to_i
  end

  def calculate_fine
    return 0 unless overdue?

    days = days_overdue
    if days <= 7
      days * 1.00 # $1 por dia
    else
      7.00 + ((days - 7) * 2.00) # $2 por dia após 7 dias
    end
  end

  private

  def due_date_after_borrowed
    return if due_date.blank? || borrowed_at.blank?

    if due_date <= borrowed_at
      errors.add(:due_date, 'must be after borrow date')
    end
  end

  def create_notification
    user.notifications.create!(
      title: 'Book Borrowed',
      message: "You have borrowed '#{book.title}', Due date #{due_date.strftime('%d-%m-%Y')}.",
      notification_type: 'loan_created'
    )
  end

  def check_fine
    return unless overdue?

    fine_amount = calculate_fine
    create_fine!(amount: fine_amount, status: 'pending') if fine_amount > 0
  end

end
