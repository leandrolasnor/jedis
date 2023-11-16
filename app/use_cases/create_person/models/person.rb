# frozen_string_literal: true

class CreatePerson::Models::Person < ApplicationRecord
  include Enums::Person::Status
  include MeiliSearch::Rails

  has_many :contacts, dependent: :destroy
  has_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true

  meilisearch auto_index: !Rails.env.test?, auto_remove: Rails.env.test?
  meilisearch index_uid: :person do
    attribute :name
    attribute :taxpayer_number
    attribute :cns
    attribute :email
    attribute :birthdate
    attribute :status
    attribute :address do
      addresses.first.attributes.except("created_at", "updated_at", "person_id")
    end
    attribute :contact do
      contacts.first.attributes.except("created_at", "updated_at", "person_id")
    end
    displayed_attributes [:id, :name, :taxpayer_number, :cns, :email, :birthdate, :status]
    searchable_attributes [:name, :taxpayer_number, :cns, :email, :birthdate, :address, :contact]
    sortable_attributes [:name, :birthdate]
  end
end
