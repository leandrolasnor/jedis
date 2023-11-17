# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "jedis@challenge.com"
  layout "mailer"
end
