# frozen_string_literal: true

class CreatePerson::Contract < ApplicationContract
  params do
    required(:name).filled(:string)
    required(:taxpayer_number).filled(:string)
    required(:cns).filled(:integer)
    required(:email).filled(:string)
    required(:birthdate).filled(:date)
    optional(:contacts_attributes).array(:hash) do
      required(:number).filled(:integer)
    end
    optional(:addresses_attributes).array(:hash) do
      required(:address).filled(:string)
      required(:number).filled(:string)
      required(:district).filled(:string)
      required(:city).filled(:string)
      required(:state).filled(:string)
      required(:zip).filled(:string)
      required(:addon).filled(:string)
      required(:ibge).filled(:string)
    end
  end

  rule(:email) do
    unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
      key.failure(:invalid_format)
    end
  end

  rule(:cns) do
    sum = value.to_s.chars.each_with_index.sum { |d, i| d.to_i * (15 - i) }
    key.failure(:cns_invalid) if value.to_s.length != 15 || sum % 11 != 0
  end

  rule(:taxpayer_number) do
    key.failure(:taxpayer_number_invalid) unless CPF.valid?(value, strict: true)
  end

  rule(:birthdate) do
    age = ((Time.zone.now - value.to_time) / 1.year.seconds).floor
    key.failure(:age_must_be_between_18_80) unless (18..80).cover?(age)
  end
end
