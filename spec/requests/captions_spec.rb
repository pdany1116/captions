# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Captions", type: :request do
  describe "GET /captions" do
    it "responds with 200" do
      get "/captions"

      expect(response).to have_http_status(:ok)
    end
  end
end
