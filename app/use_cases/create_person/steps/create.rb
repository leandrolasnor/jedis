# frozen_string_literal: true

class CreatePerson::Steps::Create
  include Dry::Events::Publisher[:proponent_create]
  include Dry.Types()
  extend  Dry::Initializer

  register_event 'person.created'

  option :model, type: Interface(:create), default: -> { CreatePerson::Models::Person }, reader: :private

  def call(params)
    record = model.create do
      _1.name = params[:name]
      _1.taxpayer_number = params[:taxpayer_number]
      _1.cns = params[:cns]
      _1.birthdate = params[:birthdate]
      _1.email = params[:email]
      _1.addresses_attributes = params[:addresses_attributes].presence || []
      _1.contacts_attributes = params[:contacts_attributes].presence || []
    end
    publish('person.created', record: record)
    record
  end
end
