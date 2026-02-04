# frozen_string_literal: true

class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :bio, :birth_date, :death_date,
             :nationality, :book_count, :average_rating

  def book_count
    object.books.count
  end
end