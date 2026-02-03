# frozen_string_literal: true
class Book < ApplicationRecord
  include Searchable

  belongs_to  :category, optional: true
  belongs_to  :author, optional: true
  belongs_to  :publisher, optional: true

  has_many  :book_copies, dependent: :destroy
  has_many  :reviews, dependent: :destroy
  has_many  :reservations, dependent: :destroy
  has_many  :favorites, dependent: :destroy

  validates :publication_year, numericality: {
    only_integer: true,
    greater_than: 0,
    less_then_or_equal_to: Date.current.year
  }
  validates :pages, numericality: { only_integer: true, greater_than: 0}

  scope :avaliable, -> {
    joins(:book_copies)
      .where(book_copies: {status: :available })
      .display
  }

  scope :by_genre, ->(genre) { where(genre: genre) }
  scope :recent, -> {where('publications_year >= ?', Date.current.year -5)}
  scope :popular, -> { order('average_rating DESC NULLS LAST')}

  def avaliable_copies
    book_copies.available
  end

  def available?
    avaialble_copies.any?
  end

  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end

  def total_reviews
    reviews.count
  end

  def update_statistics
    update(
      average_rating: reviews.average(:rating),
      total_reviews: reviews.count
    )
  end
end
