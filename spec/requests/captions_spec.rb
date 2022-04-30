# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Captions", type: :request do
  describe "GET /captions" do
    it "responds with 200" do
      get "/captions"

      expect(response).to have_http_status(:ok)
    end

    it "responds with good body" do
      get "/captions"

      expect(response.body).not_to be_empty

      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json).to eq({
                                    captions: [
                                      {
                                        id: 123,
                                        url: "https://google.com/image",
                                        text: "Hi mom!",
                                        caption_url: "https://localhost:3000/image.jpg"
                                      }
                                    ]
                                  })
    end
  end
end
