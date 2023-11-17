# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Http::UpdatePerson::NotifiesStatusUpdate::Job do
  let(:perform) { described_class.new.perform(id) }
  let(:id) { person.id }
  let(:person) { create(:person, status: :disabled) }
  let(:contact) { create(:contact, person_id: person.id, number: '+5521967483475') }
  let(:twilio) { Twilio::REST::Client.new(ENV.fetch('TWILIO_SID'), ENV.fetch('TWILIO_TOKEN')) }

  context 'on success' do
    before do
      allow(Twilio::REST::Client).
        to receive(:new).
        with(ENV.fetch('TWILIO_SID'), ENV.fetch('TWILIO_TOKEN')).
        and_return(twilio)
      allow(Rails.logger).to receive(:error)
      contact
    end

    it 'must be able to notify the person about the change of status' do
      expect(perform).to be_success
      expect(Twilio::REST::Client).to have_received(:new).with(ENV.fetch('TWILIO_SID'), ENV.fetch('TWILIO_TOKEN'))
      expect(Rails.logger).not_to have_received(:error)
    end
  end

  context 'on failure' do
    let(:contact) { create(:contact, person_id: person.id, number: '+invalid_number') }

    before do
      allow(Twilio::REST::Client).
        to receive(:new).
        with(ENV.fetch('TWILIO_SID'), ENV.fetch('TWILIO_TOKEN')).
        and_return(twilio)
      allow(Rails.logger).to receive(:error)
      contact
    end

    it 'must be able to log a error' do
      expect(perform).not_to be_success
      expect(Twilio::REST::Client).to have_received(:new).with(ENV.fetch('TWILIO_SID'), ENV.fetch('TWILIO_TOKEN'))
      expect(Rails.logger).to have_received(:error)
    end
  end
end
