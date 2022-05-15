# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "captions_api_notifications@gmail.com"
  layout "mailer"
end
