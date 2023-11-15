# frozen_string_literal: true

class CreatePerson::Models::Address < ApplicationRecord
  belongs_to :person
end
