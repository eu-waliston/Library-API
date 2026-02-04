# frozen_string_literal: true

class Publisher < ApplicationRecord
  has_many :books, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :address, :website, length: { maximum: 500 }

  scope :alphabetical, -> { order(name: :asc) }
end

