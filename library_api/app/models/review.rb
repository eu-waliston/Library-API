# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to  :user
  belongs_to  :book

  validates :rating, presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to:  0,
              less_than_or_equal_to:   5,
            }

  validates :comment, length: { maximum: 1000 }
  validates :user_id, uniqueness: { scope: :book_id, message: "can only review once" }

  after_save  :update_book_statistics
  after_destroy :update_book_statistics

  scope :recent, -> { order(created_at: :desc) }
  scope :positive, -> { where('rating => 4')}

  private

  def update_book_statistics
    book.update_statistics
  end
end
