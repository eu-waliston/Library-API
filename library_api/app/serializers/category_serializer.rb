# frozen_string_literal: true

class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :books_count

  def books_count
    object.books.count
  end
end
