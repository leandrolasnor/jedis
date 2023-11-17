# frozen_string_literal: true

class NotifiesStatusUpdate::Twilio::Models::Contact < ApplicationRecord
  belongs_to :person
end
