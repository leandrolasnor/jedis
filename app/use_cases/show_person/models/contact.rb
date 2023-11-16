# frozen_string_literal: true

class ShowPerson::Models::Contact < ApplicationRecord
  belongs_to :person
end
