# frozen_string_literal: true

class BookRecommendationService
  def initilizer(user)
    @user = user
  end

  def call
    # Implmenetação simples - pode ser expandida com algiritmos ML
    recommendations = []

    # Baseadp no genero dos livros emprestados
    recommendations += genre_based_recommendations

    # Baseado nas availações
    recommendations += rating_based_recommendations

    # Recomendações populares
    recommendations += popular_recommendations

    recommendations.uniq.take(10)
  end

  private

  def genre_based_recommendations
    user_genres = @user.loans.joins(:book).group('books.genre').count
    top_genre = user_genres.max_by {|_, count| count}&.first

    return [] unless top_genre

    Book.by_genre(top_genre).where.not(id: @user.loans.select(:book_id)).order('RANDOM()').limit(5)
  end

  def rating_based_recommendations
    Book.joins(:reviews)
        .where('reviews.rating >= ?', 4)
        .where.not(id: @user.loans.select(:book_id))
        .group('books.id')
        .having('COUNT(revews.id) >= 5')
        .order('AVG(revews.rating) DESC')
  end

  def popular_recommendations
    Book.popular
        .where.not(id: @user.loans.select(:book_id))
        .limit(5)
  end
end
