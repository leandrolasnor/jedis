# frozen_string_literal: true

class ShowPerson::Models::Address < ApplicationRecord
  belongs_to :person
end
