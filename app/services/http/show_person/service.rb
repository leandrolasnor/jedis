# frozen_string_literal: true

class Http::ShowPerson::Service < Http::Service
  option :serializer,
         type: Interface(:serializer_for),
         default: -> { Http::ShowPerson::Serializer },
         reader: :private

  option :monad,
         type: Interface(:call),
         default: -> { ShowPerson::Monad.new },
         reader: :private

  def call
    res = monad.call(params[:id])

    return [:ok, res.value!, serializer] if res.success?

    [:not_found, { error: I18n.t(:not_found) }]
  end
end
