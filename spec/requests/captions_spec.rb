# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Captions", type: :request do
  describe "GET /captions" do
    it "responds with 200" do
      get captions_path

      expect(response).to have_http_status(:ok)
    end

    it "responds with good body" do
      get captions_path

      expect(response.body).not_to be_empty

      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json).to eq({ captions: [] })
    end
  end

  describe "POST /captions" do
    subject(:post_captions) { post captions_path, params: params }

    context "with valid request body" do
      let(:params) do
        {
          caption: {
            url: "https://google.com/image",
            text: "Hi mom!"
          }
        }
      end

      it "responds with 201" do
        post_captions

        expect(response).to have_http_status(:created)
      end

      it "responds with the created caption" do
        post_captions

        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:caption]).to match(hash_including({
                                                                  url: params[:caption][:url],
                                                                  text: params[:caption][:text],
                                                                  caption_url: nil
                                                                }))
      end
    end
  end
end
