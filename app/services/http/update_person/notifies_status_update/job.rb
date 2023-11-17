# frozen_string_literal: true

class Http::UpdatePerson::NotifiesStatusUpdate::Job
  include Sidekiq::Worker
  include Dry.Types()
  extend Dry::Initializer

  option :monad, default: -> { NotifiesStatusUpdate::Twilio::Monad.new }, reader: :private

  sidekiq_options retry: false

  def perform(person_id)
    res = monad.call(id: person_id)

    return res if res.success?

    Rails.logger.error(res.exception)
    res
  end
end
