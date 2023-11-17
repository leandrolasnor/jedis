# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Http::CreatePerson::NotifiesPersonCreated::Job do
  let(:perform) { described_class.new.perform(id) }
  let(:id) { person.id }
  let(:person) { create(:person) }
  let(:mailer) { PersonMailer.welcome_email(person) }

  context 'on success' do
    before do
      allow(NotifiesPersonCreated::Mailer::Models::Person).to receive(:find).with(id).and_return(person)
      allow(PersonMailer).
        to receive(:welcome_email).
        with(person).
        and_return(mailer)
      allow(mailer).to receive(:deliver_now)
      allow(Rails.logger).to receive(:error)
    end

    it 'must be able to notify the person about the use of your data' do
      expect(perform).to be_success
      expect(NotifiesPersonCreated::Mailer::Models::Person).to have_received(:find).with(id)
      expect(mailer).to have_received(:deliver_now)
      expect(Rails.logger).not_to have_received(:error)
    end
  end

  context 'on failure' do
    let(:id) { 0 }

    before { allow(Rails.logger).to receive(:error) }

    it 'must be able to log a error' do
      expect(perform).not_to be_success
      expect(Rails.logger).to have_received(:error)
    end
  end
end
