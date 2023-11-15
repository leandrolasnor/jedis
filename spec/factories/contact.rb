# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    number { Faker::PhoneNumber.cell_phone_in_e164 }

    trait :create_person do
      initialize_with { CreatePerson::Models::Contact.new(attributes) }
    end
  end
end
