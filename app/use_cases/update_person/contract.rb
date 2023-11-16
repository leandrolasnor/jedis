# frozen_string_literal: true

module Types
  include Dry.Types()

  StatusPerson = Types::String.constructor do
    UpdatePerson::Models::Person.statuses.key(_1)
  end
end

class UpdatePerson::Contract < ApplicationContract
  params do
    required(:id).filled(:integer)
    optional(:email).filled(:string)
    optional(:status).type(Types::StatusPerson).value(included_in?: UpdatePerson::Models::Person.statuses.keys)
    optional(:contacts_attributes).array(:hash) do
      optional(:id).maybe(:integer)
      optional(:number).filled(:string)
      optional(:_destroy).maybe(:bool)
    end
    optional(:addresses_attributes).array(:hash) do
      optional(:id).maybe(:integer)
      optional(:address).filled(:string)
      optional(:number).maybe(:string)
      optional(:district).maybe(:string)
      optional(:city).maybe(:string)
      optional(:state).maybe(:string)
      optional(:zip).maybe(:string)
      optional(:addon).filled(:string)
      optional(:ibge).filled(:string)
      optional(:_destroy).maybe(:bool)
    end
  end

  rule(:email) do
    matched = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
    key.failure(:invalid_format) if key? && !matched
  end
end
