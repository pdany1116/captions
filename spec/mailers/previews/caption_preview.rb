# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/caption
class CaptionPreview < ActionMailer::Preview
  def creation_success_email
    CaptionMailer.creation_success_email(Caption.first)
  end
end
