# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    isbn { Faker::Code.isbn }
    description { Faker::Lorem.paragraph }
    publication_year { rand(1900..2023) }
    pages { rand(100..1000) }
    language { 'English' }
    genre { Faker::Book.genre }

    association :author
    association :category
    association :publisher

    trait :with_available_copies do
      after(:create) do |book|
        create_list(:book_copy, 2, book: book, status: :available)
      end
    end

    trait :with_borrowed_copies do
      after(:create) do |book|
        create_list(:book_copy, 2, book: book, status: :borrowed)
      end
    end
  end
end