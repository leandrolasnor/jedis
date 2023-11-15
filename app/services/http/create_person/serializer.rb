# frozen_string_literal: true

class Http::CreatePerson::Serializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :taxpayer_number,
             :cns,
             :email,
             :birthdate,
             :status

  has_many :addresses
  has_many :contacts
end

class AddressSerializer < ActiveModel::Serializer
  attributes :id, :address, :number, :district, :city, :state, :zip, :addon, :ibge
end

class ContactSerializer < ActiveModel::Serializer
  attributes :id, :number
end
