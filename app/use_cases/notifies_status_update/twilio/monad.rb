# frozen_string_literal: true

class NotifiesStatusUpdate::Twilio::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :provider,
         type: Instance(Object),
         default: -> { Twilio::REST::Client.new(ENV.fetch('TWILIO_SID'), ENV.fetch('TWILIO_TOKEN')) },
         reader: :private

  option :sender,
         type: Instance(Proc),
         default: -> { proc { provider.messages.create(from: _1, body: _2, to: _3) } },
         reader: :private

  option :model, type: Interface(:find), default: -> { NotifiesStatusUpdate::Twilio::Models::Person }
  option :from, default: -> { ENV.fetch('TWILIO_PHONE_NUMBER_TEST') }
  option :body, type: Instance(Proc), default: -> { proc { "Status Updated to #{_1}" } }

  def call(id:)
    Try { model.includes(:contacts).find(id) }.
      fmap { sender.(from, body.(_1.status), _1.contacts.first&.number) }
  end
end
