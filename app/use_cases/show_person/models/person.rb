# frozen_string_literal: true

class ShowPerson::Models::Person < ApplicationRecord
  has_many :addresses
  has_many :contacts
end
