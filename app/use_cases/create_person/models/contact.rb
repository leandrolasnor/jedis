# frozen_string_literal: true

class CreatePerson::Models::Contact < ApplicationRecord
  belongs_to :person
end
