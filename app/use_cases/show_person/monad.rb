# frozen_string_literal: true

class ShowPerson::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :model, type: Interface(:find), default: -> { ShowPerson::Models::Person }, reader: :private

  def call(id)
    Try(ActiveRecord::RecordNotFound) { model.find(id) }
  end
end
