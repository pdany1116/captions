# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Captions", type: :request do
  describe "GET /captions" do
    context "with no captions added" do
      it "responds with 200" do
        get captions_path

        expect(response).to have_http_status(:ok)
      end

      it "responds with array with no captions" do
        get captions_path

        expect(response.body).not_to be_empty

        response_json = JSON.parse(response.body, symbolize_names: true)
        expect(response_json).to eq({ captions: [] })
      end
    end

    context "with 5 captions added" do
      before do
        (1..5).each do |_i|
          url = Faker::LoremFlickr.image(size: "300x300", search_terms: ['beer'])
          text = Faker::Beer.brand
          params = {
            caption: {
              url: url,
              text: text
            }
          }

          post "/captions", params: params
        end
      end

      it "responds with 200 status and as body an array of 5 captions" do
        get captions_path

        response_json = JSON.parse(response.body, symbolize_names: true)
        expect(response_json[:captions].length).to eq(5)
      end
    end
  end

  describe "POST /captions" do
    subject(:post_captions) { post captions_path, params: params }

    context "with valid request body" do
      let(:url) { Faker::LoremFlickr.image(size: "300x300", search_terms: ['beer']) }
      let(:text) { Faker::Beer.brand }
      let(:caption_url) { "/images/#{Digest::MD5.hexdigest("#{url}#{text}")}.jpg" }
      let(:params) do
        {
          caption: {
            url: url,
            text: text
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
                                                                  url: url,
                                                                  text: text,
                                                                  caption_url: caption_url
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
            text: Faker::Beer.brand
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
            url: Faker::LoremFlickr.image(size: "300x300", search_terms: ['beer'])
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

    context "with invalid url value" do
      let(:params) do
        {
          caption: {
            url: url,
            text: text
          }
        }
      end

      context "with empty url" do
        let(:url) { "" }
        let(:text) { Faker::Beer.brand }

        it "returns 422" do
          post_captions

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid url value" do
          post_captions

          response_json = JSON.parse(response.body, symbolize_names: true)

          expect(response_json[:errors].first).to match(hash_including({
                                                                         code: "invalid_parameters",
                                                                         title: "Invalid parameters in request body",
                                                                         description: "Url can't be blank"
                                                                       }))
        end
      end

      context "with nil url" do
        let(:url) { nil }
        let(:text) { Faker::Beer.brand }

        it "returns 422" do
          post_captions

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid url value" do
          post_captions

          response_json = JSON.parse(response.body, symbolize_names: true)

          expect(response_json[:errors].first).to match(hash_including({
                                                                         code: "invalid_parameters",
                                                                         title: "Invalid parameters in request body",
                                                                         description: "Url can't be blank"
                                                                       }))
        end
      end

      context "with non image (jpeg, jpg, png) url" do
        let(:url) { Faker::Internet.url(path: Faker::File.file_name(ext: "mp3")) }
        let(:text) { Faker::Beer.brand }

        it "returns 422",
           skip: "Not implemented yet" do
          post_captions

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid url value",
           skip: "Not implemented yet" do
          post_captions

          response_json = JSON.parse(response.body, symbolize_names: true)

          expect(response_json[:errors].first).to match(hash_including({
                                                                         code: "invalid_parameters",
                                                                         title: "Invalid parameters in request body",
                                                                         description: "url does not have jpg/jpeg/png format"
                                                                       }))
        end
      end
    end

    context "with invalid text value" do
      let(:params) do
        {
          caption: {
            url: url,
            text: text
          }
        }
      end

      context "with empty text" do
        let(:url) { Faker::LoremFlickr.image(size: "300x300", search_terms: ['beer']) }
        let(:text) { "" }

        it "returns 422" do
          post_captions

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid text value" do
          post_captions

          response_json = JSON.parse(response.body, symbolize_names: true)

          expect(response_json[:errors].first).to match(hash_including({
                                                                         code: "invalid_parameters",
                                                                         title: "Invalid parameters in request body",
                                                                         description: "Text can't be blank"
                                                                       }))
        end
      end

      context "with text url" do
        let(:url) { Faker::LoremFlickr.image(size: "300x300", search_terms: ['beer']) }
        let(:text) { nil }

        it "returns 422" do
          post_captions

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid text value" do
          post_captions

          response_json = JSON.parse(response.body, symbolize_names: true)

          expect(response_json[:errors].first).to match(hash_including({
                                                                         code: "invalid_parameters",
                                                                         title: "Invalid parameters in request body",
                                                                         description: "Text can't be blank"
                                                                       }))
        end
      end

      context "with text too long" do
        let(:url) { Faker::LoremFlickr.image(size: "300x300", search_terms: ['beer']) }
        let(:text) { Faker::String.random(length: 300) }

        it "returns 422" do
          post_captions

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid text value" do
          post_captions

          response_json = JSON.parse(response.body, symbolize_names: true)

          expect(response_json[:errors].first).to match(hash_including({
                                                                         code: "invalid_parameters",
                                                                         title: "Invalid parameters in request body",
                                                                         description: "Text is too long (maximum is 266 characters)"
                                                                       }))
        end
      end
    end
  end

  describe "DELETE /captions" do
    context "with existing caption" do
      it "returns 200" do
        post captions_path, params: {
          caption: {
            url: Faker::LoremFlickr.image(size: "300x300", search_terms: ['beer']),
            text: Faker::Beer.brand
          }
        }

        id = JSON.parse(response.body, symbolize_names: true)[:caption][:id]

        delete "/captions/#{id}"

        expect(response).to have_http_status(:ok)
      end
    end

    context "with not existing caption" do
      let(:id) { Faker::Number.number }

      before do
        get captions_path

        expect(JSON.parse(response.body, symbolize_names: true)[:captions].length).to eq 0
      end

      it "returns 404" do
        delete "/captions/#{id}"

        expect(response).to have_http_status(:not_found)
      end

      it "returns an error body with caption not found message" do
        delete "/captions/#{id}"

        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:errors].first).to match(hash_including({
                                                                       code: "not_found",
                                                                       title: "Caption not found",
                                                                       description: "Couldn't find Caption with 'id'=#{id}"
                                                                     }))
      end
    end
  end

  describe "GET /captions/:id" do
    context "with existing caption" do
      let(:url) { Faker::LoremFlickr.image(size: "300x300", search_terms: ['beer']) }
      let(:text) { Faker::Beer.brand }
      let(:caption_url) { "/images/#{Digest::MD5.hexdigest("#{url}#{text}")}.jpg" }
      let(:params) do
        {
          caption: {
            url: url,
            text: text
          }
        }
      end

      it "returns 200 and specifed caption as JSON" do
        post captions_path, params: params
        expect(response).to have_http_status(:created)

        id = JSON.parse(response.body, symbolize_names: true)[:caption][:id]

        get "/captions/#{id}"
        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(response_json[:caption]).to match(hash_including({
                                                                  url: url,
                                                                  text: text,
                                                                  caption_url: caption_url
                                                                }))
      end
    end

    context "with not existing caption" do
      let(:id) { Faker::Number.number }

      before do
        get captions_path

        expect(JSON.parse(response.body, symbolize_names: true)[:captions].length).to eq 0
      end

      it "returns 404" do
        get "/captions/#{id}"

        expect(response).to have_http_status(:not_found)
      end

      it "returns an error body with caption not found message" do
        get "/captions/#{id}"

        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:errors].first).to match(hash_including({
                                                                       code: "not_found",
                                                                       title: "Caption not found",
                                                                       description: "Couldn't find Caption with 'id'=#{id}"
                                                                     }))
      end
    end
  end
end
