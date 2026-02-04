# frozen_string_literal: true

class LoanSerializer < ActiveModel::Serializer
  attributes :id, :borrowed_at, :due_date, :returned_at,
             :overdue, :days_ovedue, :fine_amount

  belongs_to :user, serializer: UserSerializer
  belongs_to  :book_copy
  has_one :book, serializer: BookSerializer

  def overdue
    object.overdue?
  end

  def days_ovedueue
    object.days_overdue
  end

  def fine_amount
    object.calculate_fine
  end
end
