# frozen_string_literal: true

class UpdatePerson::Steps::Update
  include Dry::Events::Publisher[:update_person]
  include Dry.Types()
  extend  Dry::Initializer

  register_event 'person.updated'
  register_event 'person.status.updated'

  def call(record:, **params)
    record.update!(params)

    publish('person.status.updated', record: record) if record.previous_changes.key?(:status)
    publish('person.updated', record: record)
    record
  end
end
