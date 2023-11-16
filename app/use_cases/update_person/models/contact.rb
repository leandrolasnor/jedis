# frozen_string_literal: true

class UpdatePerson::Models::Contact < ApplicationRecord
  belongs_to :person
end
