# app/models/reservation.rb
class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :book_copy
  has_one :book, through: :book_copy

  validates :reserved_at, presence: true
  validate :book_copy_must_be_available

  scope :active, -> { where(canceled_at: nil).where('expires_at > ?', Time.current) }
  scope :expired, -> { where('expires_at <= ?', Time.current) }
  scope :canceled, -> { where.not(canceled_at: nil) }

  before_create :set_expiration
  after_create :notify_reservation_created
  after_update :notify_reservation_canceled, if: :canceled_at_changed?

  def cancel
    update!(canceled_at: Time.current)
    book_copy.update!(status: :available) if book_copy.reserved?
  end

  def fulfill
    return false unless active?

    transaction do
      update!(fulfilled_at: Time.current)
      book_copy.borrow(user)
    end
  end

  def active?
    canceled_at.nil? && expires_at > Time.current
  end

  private

  def set_expiration
    self.expires_at = reserved_at + 7.days
  end

  def book_copy_must_be_available
    return if book_copy.nil?

    if !book_copy.available?
      errors.add(:book_copy, 'must be available for reservation')
    end
  end

  def notify_reservation_created
    user.notifications.create!(
      title: 'Book Reserved',
      message: "You have reserved '#{book.title}'. Reservation expires on #{expires_at.strftime('%Y-%m-%d %H:%M')}",
      notification_type: 'reservation_created'
    )
  end

  def notify_reservation_canceled
    user.notifications.create!(
      title: 'Reservation Canceled',
      message: "Your reservation for '#{book.title}' has been canceled.",
      notification_type: 'reservation_canceled'
    )
  end
end