# frozen_string_literal: true

# app/controllers/api/v1/books_controller.rb
module Api
  module V1
    class BooksController < BaseController
      before_action :set_book, only: [:show, :update, :destroy, :borrow]

      def index
        authorize Book

        books = policy_scope(Book)
                  .includes(:author, :category)
                  .order(created_at: :desc)

        # Filtros
        books = books.by_genre(params[:genre]) if params[:genre]
        books = books.available if params[:available] == 'true'

        # Busca
        if params[:q]
          books = books.search(params[:q])
        end

        # Paginação
        books = books.page(params[:page]).per(params[:per_page] || 20)

        render json: {
          books: ActiveModelSerializers::SerializableResource.new(
            books,
            each_serializer: BookSerializer
          ),
          meta: pagination_meta(books)
        }
      end

      def show
        authorize @book

        render json: @book, serializer: BookDetailSerializer
      end

      def create
        authorize Book

        @book = Book.new(book_params)

        if @book.save
          # Criar cópias iniciais do livro
          params[:initial_copies].to_i.times do
            @book.book_copies.create!(
              status: :available,
              acquisition_date: Date.current
            )
          end

          render json: @book,
                 serializer: BookSerializer,
                 status: :created
        else
          render json: { errors: @book.errors },
                 status: :unprocessable_entity
        end
      end

      def update
        authorize @book

        if @book.update(book_params)
          render json: @book, serializer: BookSerializer
        else
          render json: { errors: @book.errors },
                 status: :unprocessable_entity
        end
      end

      def destroy
        authorize @book

        @book.destroy
        head :no_content
      end

      def borrow
        authorize @book, :borrow?

        copy = @book.available_copies.first

        if copy && current_user.can_borrow?
          loan = copy.borrow(current_user)

          if loan
            render json: {
              message: 'Book borrowed successfully',
              loan: LoanSerializer.new(loan)
            }, status: :ok
          else
            render json: { error: 'Failed to borrow book' },
                   status: :unprocessable_entity
          end
        else
          render json: { error: 'No available copies or user cannot borrow' },
                 status: :unprocessable_entity
        end
      end

      def recommendations
        authorize Book

        # Lógica de recomendação baseada no histórico do usuário
        recommendations = BookRecommendationService.new(current_user).call

        render json: recommendations,
               each_serializer: BookSerializer
      end

      private

      def set_book
        @book = Book.find(params[:id])
      end

      def book_params
        params.require(:book).permit(
          :title, :isbn, :description, :publication_year,
          :pages, :language, :genre, :cover_image,
          :author_id, :category_id, :publisher_id
        )
      end
    end
  end
end