# frozen_string_literal: true

class BookCopy < ApplicationRecord

  belongs_to  :book
  belongs_to  :location, optional: true
  has_many    :loans, dependent: :restrict_with_error
  has_one     :current_loan, -> { where(returned_at: nil) }, class_name: 'Loan'

  enum status: { available: 0, borrowed: 1, reserved: 2, maintenance: 3, lost: 4 }

  validates :barcode, presence: true, uniqueness: true
  validates :acquisition_date, presence: true
  validates :status, presence: true

  before_validation :generate_barcode, on: create

  def borrow(user, due_date = 14.days.from_now)
    return false unless available?

    transaction do
      update!(status: :borrowed)
      loans.create!(
        user: user,
        borrowe_at: Time.current,
        due_date: due_date
      )
    end
  end

  def return
    return false unless borrowed?

    transaction do
      update!(status: :available)
      current_loan&.update!(returned_at: Time.current)
    end
  end

  def reserve(user)
    return false unless available?

    transaction do
      update!(status: :reserved)
      Reservation.create!(user: user, book_copy: self, reserved_at: Time.current)
    end
  end

  private

  def generate_barcode
    self.barcode ||= "BK#{SecureRandom.hex(8).upcase}"
  end

end
