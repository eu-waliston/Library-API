# frozen_string_literal: true

class Author < AplicationRecord
  include Searchable

  has_many :books, dependent: :destroy

  validates :name, presence: true, length: { maximum: 200}
  validates :bio, length: { maximum: 1000}
  validates :nationality, length: { maximum: 100}

  scope :alphabetical, -> { order(:name)}
  scope :with_books, -> { joins(:books).distinct }

  def book_count
    books.count
  end

  def average_rating
    books.joins(:reviews).average(:rating)&.round(1) || 0
  end
end
