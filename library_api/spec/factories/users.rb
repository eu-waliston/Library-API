# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    role { :member }

    trait :librarian do
      role { :librarian }
    end

    trait :admin do
      role { :admin }
    end
  end
end