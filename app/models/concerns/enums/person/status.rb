# frozen_string_literal: true

module Enums::Person::Status
  extend ActiveSupport::Concern

  included do
    enum :status, [:disabled, :enabled]
  end
end
