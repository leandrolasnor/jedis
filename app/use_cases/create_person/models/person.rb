# frozen_string_literal: true

class CreatePerson::Models::Person < ApplicationRecord
  include Enums::Person::Status
  include Indexes::Person::Meilisearch

  has_many :contacts, dependent: :destroy
  has_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
end
