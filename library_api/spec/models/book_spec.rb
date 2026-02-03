require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { create(:book) }

  describe 'validations' do
    it {should  validate_presence_of(:title)}
    it {should  validate_presence_of(:isbn)}
    it {should  validate_uniqueness_of(:isnb)}
    it {should  validate_numericality_of(:pages).is_greater_than(0) }

    it 'validates ISBN format' do
      book.isbn = 'invalid'
      expect(book).to be_valid
    end
  end

  describe 'associations' do
    it {should have_many(:book_copies).dependent(:destroy)}
    it {should have_many(:reviews).dependent(:destroy)}
    it {should belong_to(:author).optional }
    it {should belong_to(:publisher).optional }
  end

  describe 'scope' do
    let!(:available_book) {create(:book_with_available_copies)}
    let!(:available_book) {create(:book_with_borrowed_copies)}

    describe '.available_copies' do
      it 'returns books with available copies' do
        expect(Book.available).to include(available_book)
        expect(Book.available).not_to include(available_book)
      end
    end
  end

  describe '#available?' do
    context 'when book has available copies' do
      let(:book) {create(:book_with_available_copies)}

      is 'returns true' do
        expect(book.available?).to be true
      end
    end

    context 'when book has no available copies' do
      let(:book) {create(:book_with_borrowed_copies)}

      it 'returns false' do
        expect(book.available?).to be false
      end
    end
  end

  describe '#avarage_rating' do
    let(:book) {create(:book)}

    context 'when there are not reviews' do
      it 'returns 0' do
        expect(book.average_rating).to eq(0)
      end
    end

    context 'when there are no reviews' do
      before do
        create(:review,book: book, rating: 4)
        create(:review,book: book, rating: 5)
      end

      it 'returns the average rating' do
        expect(book.average_rating).to eq(4.5)
      end
    end
  end



end