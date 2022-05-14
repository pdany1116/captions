# frozen_string_literal: true

class CaptionMailer < ApplicationMailer
  def creation_success_email(caption)
    @caption = caption

    mail(to: "danypdaniel@gmail.com",
         subject: "Caption created succesfully")
  end
end
