# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Captions", type: :request do
  describe "Creating a caption" do
    subject(:post_captions) { post captions_path, params: params }

    context "when requesting all captions" do
      let(:url) { Faker::Internet.url }
      let(:text) { Faker::String.random }
      let(:params) do
        {
          caption: {
            url: url,
            text: text
          }
        }
      end

      it "responds with the new created caption" do
        post captions_path, params: params
        get captions_path

        response_json = JSON.parse(response.body, symbolize_names: true)
        expect(response_json[:captions].first).to match(hash_including({ url: url, text: text }))
      end
    end
  end
end
