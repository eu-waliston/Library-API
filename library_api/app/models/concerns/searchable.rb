# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def search(query)
      return all if query.blank?

      where(
        "LOWER(title) LIKE :query OR
         LOWER(description) LIKE :query OR
         LOWER(isbn) LIKE :query OR
         EXISTS (
           SELECT 1 FROM authors
           WHERE authors.id = books.author_id
           AND LOWER(authors.name) LIKE :query
         )",
        query: "%#{query.downcase}%"
      )
    end
  end
end
