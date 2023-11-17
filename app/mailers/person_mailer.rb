# frozen_string_literal: true

class PersonMailer < ApplicationMailer
  def welcome_email(person)
    @person = person
    mail(to: @person.email, subject: t('mailer.person.welcome'))
  end
end
