# frozen_string_literal: true

class ImagesController < ApplicationController
  def show
    id = params[:id]
    send_file Rails.root.join("#{images_dir}#{id}"), type: "image/jpeg"
  rescue ActionController::MissingFile
    render json: { errors: [not_found_error(id)] }, status: :not_found
  end

  private

  def images_dir
    if ENV["RAILS_ENV"] == "test"
      "spec/images/"
    else
      "images/"
    end
  end

  def not_found_error(id)
    {
      code: "not_found",
      title: "Image not found",
      description: "Couldn't find Image with 'id'=#{id}"
    }
  end
end
