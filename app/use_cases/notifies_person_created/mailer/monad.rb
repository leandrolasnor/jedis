# frozen_string_literal: true

class NotifiesPersonCreated::Mailer::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :sender,
         type: Instance(Proc),
         default: -> { proc { PersonMailer.welcome_email(_1).deliver_now } },
         reader: :private

  option :model, type: Interface(:find), default: -> { NotifiesPersonCreated::Mailer::Models::Person }

  def call(id:)
    Try { model.find(id) }.fmap { sender.(_1) }
  end
end
