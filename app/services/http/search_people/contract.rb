# frozen_string_literal: true

class Http::SearchPeople::Contract < ApplicationContract
  params do
    required(:page).filled(:integer)
    optional(:per_page).filled(:integer)
    optional(:query).maybe(:string)
  end
end
