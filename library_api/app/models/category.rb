# frozen_string_literal: true

class Category < AplicationRecord
  has_many  :books, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 500 }

  scope :with_books, -> { joins(:books).distinct }
  scope :popular, -> {
    left_joins(:books)
      .group(:id)
      .order('COUNT(books.id) DESC')
  }
end
