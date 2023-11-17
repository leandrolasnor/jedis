# frozen_string_literal: true

class Http::UpdatePerson::Service < Http::Service
  option :serializer,
         type: Interface(:serializer_for),
         default: -> { Http::UpdatePerson::Serializer },
         reader: :private

  option :transaction, type: Interface(:call), default: -> { UpdatePerson::Transaction.new }, reader: :private
  option :job, type: Interface(:perform_async), default: -> { Http::UpdatePerson::NotifiesStatusUpdate::Job }
  option :enqueuer, type: Instance(Proc), default: -> { proc { job.perform_async(_1) } }, reader: :private

  def call
    transaction.operations[:update].subscribe('person.status.updated') do
      enqueuer.(_1[:record].id)
    end

    transaction.call(params) do
      _1.failure :validate do |f|
        [:unprocessable_entity, f.errors.to_h]
      end

      _1.failure :find do
        [:not_found, { error: I18n.t(:not_found) }]
      end

      _1.failure do |f|
        Rails.logger.error(f)
        [:internal_server_error]
      end

      _1.success do |updated|
        [:ok, updated, serializer]
      end
    end
  end
end
