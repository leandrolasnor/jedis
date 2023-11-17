# frozen_string_literal: true

class NotifiesStatusUpdate::Twilio::Models::Person < ApplicationRecord
  include Enums::Person::Status

  has_many :contacts, dependent: :destroy
end
