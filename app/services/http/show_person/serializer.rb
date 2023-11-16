# frozen_string_literal: true

class Http::ShowPerson::Serializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :taxpayer_number,
             :cns,
             :birthdate,
             :email

  has_many :addresses
  has_many :contacts
end

class AddressSerializer < ActiveModel::Serializer
  attributes :id, :address, :number, :district, :city, :state, :zip
end

class ContactSerializer < ActiveModel::Serializer
  attributes :id, :number
end
