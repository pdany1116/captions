# frozen_string_literal: true

require "rails_helper"

RSpec.describe CaptionMailer, type: :mailer do
  describe "#creation_success_email" do
    subject(:mail) { described_class.creation_success_email(caption) }

    context "with valid caption" do
      let(:url) { Faker::LoremFlickr.image(size: "300x300", search_terms: ['beer']) }
      let(:text) { Faker::Beer.brand }
      let(:caption_url) { "/images/#{Digest::MD5.hexdigest("#{url}#{text}")}.jpg" }
      let(:caption) { Caption.new(url: url, text: text, caption_url: caption_url) }

      it "creates the correct subject" do
        expect(mail.subject).to eq "Caption created succesfully"
      end

      it "creates the correct body" do
        email_body = "Caption created succesfully at #{caption.created_at}! Access it at: #{caption.caption_url}"

        expect(mail.body.include?(email_body)).to be true
      end

      it "creates the correct receptor" do
        expect(mail.to.include?("danypdaniel@gmail.com")).to be true
      end

      it "creates the correct sender" do
        expect(mail.from.include?("captions_api_notifications@gmail.com")).to be true
      end

      context "when sending mail" do
        it "increases the number of sent mails" do
          expect { mail.deliver_now }.to change { described_class.deliveries.count }.by(1)
        end
      end
    end
  end
end
