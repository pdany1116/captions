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

  def create
    caption = {
      caption: {
        id: 123,
        url: params[:caption][:url],
        text: params[:caption][:text],
        caption_url: "https://localhost:3000/image.jpg"
      }
    }
    render json: caption, status: :created
  end
end
