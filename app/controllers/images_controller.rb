# frozen_string_literal: true

require "./lib/utils"

class ImagesController < ApplicationController
  def show
    image_name = "#{params[:id]}.#{params[:format]}"

    send_file Rails.root.join("#{Utils.images_dir}#{image_name}"), type: "image/jpeg"
  rescue ActionController::MissingFile
    render json: { errors: [not_found_error(image_name)] }, status: :not_found
  end

  private

  def not_found_error(image_name)
    {
      code: "not_found",
      title: "Image not found",
      description: "Couldn't find Image #{image_name}"
    }
  end
end
