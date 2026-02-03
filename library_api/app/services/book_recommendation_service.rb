# app/services/book_recommendation_service.rb
class BookRecommendationService
  def initialize(user)
    @user = user
  end

  def call
    # Implementação simples - pode ser expandida com algoritmos ML
    recommendations = []

    # Baseado no gênero dos livros emprestados
    recommendations += genre_based_recommendations

    # Baseado nas avaliações
    recommendations += rating_based_recommendations

    # Recomendações populares
    recommendations += popular_recommendations

    recommendations.uniq.take(10)
  end

  private

  def genre_based_recommendations
    user_genres = @user.loans.joins(:book).group('books.genre').count
    top_genre = user_genres.max_by { |_, count| count }&.first

    return [] unless top_genre

    Book.by_genre(top_genre)
        .where.not(id: @user.loans.select(:book_id))
        .order('RANDOM()')
        .limit(5)
  end

  def rating_based_recommendations
    Book.joins(:reviews)
        .where('reviews.rating >= ?', 4)
        .where.not(id: @user.loans.select(:book_id))
        .group('books.id')
        .having('COUNT(reviews.id) >= 5')
        .order('AVG(reviews.rating) DESC')
        .limit(5)
  end

  def popular_recommendations
    Book.popular
        .where.not(id: @user.loans.select(:book_id))
        .limit(5)
  end
end