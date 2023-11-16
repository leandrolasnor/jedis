# frozen_string_literal: true

class UpdatePerson::Steps::Find
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:find), default: -> { UpdatePerson::Models::Person }, reader: :private

  def call(params)
    params.to_h.merge(record: model.find(params[:id]))
  end
end
