# frozen_string_literal: true

class NotifiesPersonCreated::Mailer::Models::Person < ApplicationRecord
  include Enums::Person::Status
end
