# frozen_string_literal: true

class UpdatePerson::Container
  extend Dry::Container::Mixin

  register 'steps.validate', -> { UpdatePerson::Steps::Validate.new }
  register 'steps.find', -> { UpdatePerson::Steps::Find.new }
  register 'steps.update', -> { UpdatePerson::Steps::Update.new }
end
