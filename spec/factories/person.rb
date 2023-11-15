# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    name { Faker::FunnyName.two_word_name }
    taxpayer_number { CPF.generate }
    cns { "230351998000003" }
    email { Faker::Internet.email(name: name, separators: ['_']) }
    birthdate { 30.years.ago.to_date }

    trait :create_person do
      initialize_with { CreatePerson::Models::Person.new(attributes) }
    end
  end
end
