# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    address { Faker::Address.full_address }
    number { Faker::Address.building_number }
    district { Faker::Address.community }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    addon { "#{Faker::Address.latitude}, #{Faker::Address.longitude}" }
    ibge { Faker::Barcode.ean_with_composite_symbology }

    trait :create_person do
      initialize_with { CreatePerson::Models::Address.new(attributes) }
    end
  end
end
