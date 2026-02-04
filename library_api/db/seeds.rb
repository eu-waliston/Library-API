# db/seeds.rb
puts "Cleaning database..."
User.destroy_all
Author.destroy_all
Category.destroy_all
Publisher.destroy_all
Book.destroy_all

puts "Creating admin user..."
User.create!(
  email: 'admin@library.com',
  password: 'admin123',
  first_name: 'Admin',
  last_name: 'User',
  role: :admin
)

puts "Creating librarian..."
User.create!(
  email: 'librarian@library.com',
  password: 'lib123',
  first_name: 'John',
  last_name: 'Librarian',
  role: :librarian
)

puts "Creating categories..."
categories = ['Fiction', 'Non-Fiction', 'Science', 'Technology', 'Biography', 'History', 'Art', 'Poetry']
categories.each do |cat|
  Category.create!(name: cat, description: "#{cat} books collection")
end

puts "Creating publishers..."
5.times do
  Publisher.create!(
    name: Faker::Book.publisher,
    address: Faker::Address.full_address,
    website: Faker::Internet.url
  )
end

puts "Creating authors..."
20.times do
  Author.create!(
    name: Faker::Book.author,
    bio: Faker::Lorem.paragraph(sentence_count: 3),
    birth_date: Faker::Date.birthday(min_age: 30, max_age: 90),
    nationality: Faker::Nation.nationality
  )
end

puts "Creating books..."
50.times do
  book = Book.create!(
    title: Faker::Book.title,
    isbn: Faker::Code.isbn,
    description: Faker::Lorem.paragraph(sentence_count: 5),
    publication_year: rand(1900..2023),
    pages: rand(100..800),
    language: ['English', 'Portuguese', 'Spanish', 'French'].sample,
    genre: Faker::Book.genre,
    author: Author.all.sample,
    category: Category.all.sample,
    publisher: Publisher.all.sample
  )

  # Create copies for each book
  rand(1..5).times do
    book.book_copies.create!(
      status: [:available, :borrowed, :available].sample,
      acquisition_date: Faker::Date.backward(days: 365)
    )
  end
end

puts "Creating regular users..."
10.times do |i|
  User.create!(
    email: "user#{i}@library.com",
    password: 'password123',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: :member
  )
end

puts "Creating some loans..."
User.where(role: :member).each do |user|
  rand(0..3).times do
    copy = BookCopy.available.sample
    next unless copy

    copy.borrow(user, rand(7..21).days.from_now)
  end
end

puts "Creating some reviews..."
Book.all.sample(20).each do |book|
  User.where(role: :member).sample(rand(1..5)).each do |user|
    Review.create!(
      user: user,
      book: book,
      rating: rand(3..5),
      comment: Faker::Lorem.paragraph
    )
  end
end

puts "Database seeded successfully!"