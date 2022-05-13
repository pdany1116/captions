# frozen_string_literal: true

require "./lib/utils"
require "./lib/error_messages"

class ImagesController < ApplicationController
  def show
    image_name = "#{params[:id]}.#{params[:format]}"

    send_file Rails.root.join("#{Utils.images_dir}#{image_name}"), type: "image/jpeg"
  rescue ActionController::MissingFile
    error = ImageNotFoundErrorMessage.new("Couldn't find Image #{image_name}").body
    render json: { errors: [error] }, status: :not_found
  end
end
