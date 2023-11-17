# frozen_string_literal: true

class Http::SearchPeople::Service < Http::Service
  option :monad, type: Interface(:call), default: -> { SearchPeople::Monad.new }, reader: :private

  Contract = Http::SearchPeople::Contract.new

  def call
    res = monad.call(**params.symbolize_keys)

    return [:ok, res.value!] if res.success?

    Rails.logger.error(res.exception)
    [:internal_server_error, res.exception.message]
  end
end
