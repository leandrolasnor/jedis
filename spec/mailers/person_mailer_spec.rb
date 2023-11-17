# frozen_string_literal: true

require "rails_helper"

RSpec.describe PersonMailer do
  context 'on welcome_email' do
    let(:person) { create(:person) }
    let(:mail) { described_class.welcome_email(person).deliver_now }

    it 'must be able to send email' do
      expect { mail }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(mail.subject).to eq(I18n.t('mailer.person.welcome'))
      expect(mail.to).to eq([person.email])
      expect(mail.from).to eq(['jedis@challenge.com'])
      expect(mail.body.encoded).to match(person.name)
      expect(mail.body.encoded).to match(person.taxpayer_number)
    end
  end
end
