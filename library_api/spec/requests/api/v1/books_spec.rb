# spec/requests/api/v1/books_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Books', type: :request do
  let(:user) { create(:user, role: :member) }
  let(:admin) { create(:user, role: :admin) }
  let(:headers) { { 'Authorization' => "Bearer #{jwt_token_for(user)}" } }
  let(:admin_headers) { { 'Authorization' => "Bearer #{jwt_token_for(admin)}" } }

  describe 'GET /api/v1/books' do
    let!(:books) { create_list(:book, 3) }

    context 'when user is authenticated' do
      before { get '/api/v1/books', headers: headers }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all books' do
        expect(json_response['books'].size).to eq(3)
      end
    end

    context 'with pagination' do
      before { get '/api/v1/books?page=1&per_page=2', headers: headers }

      it 'returns paginated results' do
        expect(json_response['books'].size).to eq(2)
        expect(json_response['meta']['current_page']).to eq(1)
      end
    end

    context 'when filtering by genre' do
      let!(:fiction_book) { create(:book, genre: 'Fiction') }

      before { get '/api/v1/books?genre=Fiction', headers: headers }

      it 'returns only books with specified genre' do
        expect(json_response['books'].size).to eq(1)
        expect(json_response['books'].first['genre']).to eq('Fiction')
      end
    end
  end

  describe 'POST /api/v1/books' do
    let(:valid_params) do
      {
        book: {
          title: 'New Book',
          isbn: '9783161484100',
          description: 'A great book',
          publication_year: 2023,
          pages: 300,
          genre: 'Fiction'
        }
      }
    end

    context 'when user is admin' do
      before do
        post '/api/v1/books',
             params: valid_params,
             headers: admin_headers
      end

      it 'creates a new book' do
        expect(response).to have_http_status(:created)
        expect(json_response['title']).to eq('New Book')
      end
    end

    context 'when user is not admin' do
      before do
        post '/api/v1/books',
             params: valid_params,
             headers: headers
      end

      it 'returns forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST /api/v1/books/:id/borrow' do
    let(:book) { create(:book_with_available_copies) }

    context 'when user can borrow' do
      before do
        post "/api/v1/books/#{book.id}/borrow",
             headers: headers
      end

      it 'borrows the book successfully' do
        expect(response).to have_http_status(:ok)
        expect(json_response['message']).to eq('Book borrowed successfully')
      end
    end

    context 'when user has too many loans' do
      before do
        # Criar 5 empréstimos ativos
        create_list(:loan, 5, user: user)
        post "/api/v1/books/#{book.id}/borrow",
             headers: headers
      end

      it 'returns error' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to include('cannot borrow')
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end