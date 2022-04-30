# frozen_string_literal: true

class CaptionsController < ApplicationController
  def index
    captions = {
      captions: [
        {
          id: 123,
          url: "https://google.com/image",
          text: "Hi mom!",
          caption_url: "https://localhost:3000/image.jpg"
        }
      ]
    }
    render json: captions, status: :ok
  end
end
