# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/images" do
  describe "GET /images/:id" do
    context "with existing image" do
      let(:url) { "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg" }
      let(:text) { "hi mom!" }

      before do
        post "/captions", params: {
          caption: {
            url: url,
            text: text
          }
        }

        caption_url = JSON.parse(response.body, symbolize_names: true)[:caption][:caption_url]

        get caption_url
      end

      after do
        FileUtils.rm_r("spec/images/*")
      end

      it "returns 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns an image content-type in header" do
        expect(response.content_type).to eq "image/jpeg"
      end

      it "returns a body with content" do
        expect(response.length).not_to eq 0
      end
    end

    context "with not existing image" do
      let(:id) { Faker::Number.hexadecimal(digits: 16) }

      before do
        get "/images/#{id}"
      end

      it "returns 404" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error body with image not found message" do
        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:errors].first).to match(hash_including({
                                                                       code: "not_found",
                                                                       title: "Image not found",
                                                                       description: "Couldn't find Image with 'id'=#{id}"
                                                                     }))
      end
    end
  end
end
