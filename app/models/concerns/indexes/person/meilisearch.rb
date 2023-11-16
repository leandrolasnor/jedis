# frozen_string_literal: true

module Indexes::Person::Meilisearch
  extend ActiveSupport::Concern
  include MeiliSearch::Rails

  included do
    meilisearch auto_index: !Rails.env.test?, auto_remove: Rails.env.test?
    meilisearch index_uid: :person do
      attribute :name
      attribute :taxpayer_number
      attribute :cns
      attribute :email
      attribute :birthdate
      attribute :status
      attribute :address do
        addresses.first&.attributes&.except("created_at", "updated_at", "person_id") if addresses.present?
      end
      attribute :contact do
        contacts.first&.attributes&.except("created_at", "updated_at", "person_id") if contacts.present?
      end
      displayed_attributes [:id, :name, :taxpayer_number, :cns, :email, :birthdate, :status]
      searchable_attributes [:name, :taxpayer_number, :cns, :email, :birthdate, :address, :contact]
      sortable_attributes [:name, :birthdate]
    end
  end
end
