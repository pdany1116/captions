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
            url: Faker::Internet.url,
            text: Faker::String.random
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

    context "with missing root element caption in request body" do
      let(:params) { {} }

      it "returns 400" do
        post_captions

        expect(response).to have_http_status(:bad_request)
      end

      it "returns an error body with caption invalid parameters message" do
        post_captions

        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:errors].first).to match(hash_including({
                                                                       code: "invalid_parameters",
                                                                       title: "Invalid parameters in request body",
                                                                       description: "param is missing or the value is empty: caption"
                                                                     }))
      end
    end

    context "with missing url element in request body" do
      let(:params) do
        {
          caption: {
            text: Faker::String.random
          }
        }
      end

      it "returns 400" do
        post_captions

        expect(response).to have_http_status(:bad_request)
      end

      it "returns an error body with url invalid parameters message" do
        post_captions

        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:errors].first).to match(hash_including({
                                                                       code: "invalid_parameters",
                                                                       title: "Invalid parameters in request body",
                                                                       description: "param is missing or the value is empty: url"
                                                                     }))
      end
    end

    context "with missing text element in request body" do
      let(:params) do
        {
          caption: {
            url: Faker::Internet.url
          }
        }
      end

      it "returns 400" do
        post_captions

        expect(response).to have_http_status(:bad_request)
      end

      it "returns an error body with text invalid parameters message" do
        post_captions

        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:errors].first).to match(hash_including({
                                                                       code: "invalid_parameters",
                                                                       title: "Invalid parameters in request body",
                                                                       description: "param is missing or the value is empty: text"
                                                                     }))
      end
    end
  end
end
