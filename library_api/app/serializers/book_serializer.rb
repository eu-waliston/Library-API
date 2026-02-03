# frozen_string_literal: true

class BookSerializer < ActiveModel::Serializer
  attributes  :id, :title,  :isbn, :description, :publication_year,
              :pages, :language, :genre, :cover_image,
              :average_rating, :total_revews, :available,
              :created_at, :updated_at

  belongs_to  :author, serializer: AuthorSerializer
  belongs_to  :category, serializer: CategorySerializer
  belongs_to  :publisher, serializer: PublisherSerializer

  def available
    object.available?
  end
end
