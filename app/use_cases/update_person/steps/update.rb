# frozen_string_literal: true

class UpdatePerson::Steps::Update
  include Dry::Events::Publisher[:update_person]
  include Dry.Types()
  extend  Dry::Initializer

  register_event 'person.updated'

  def call(record:, **params)
    ApplicationRecord.transaction do
      record.with_lock do
        record.update!(params)
      end
      publish('person.updated', record: record)
      record
    end
  end
end
