# frozen_string_literal: true

class UpdatePerson::Models::Address < ApplicationRecord
  belongs_to :person
end
