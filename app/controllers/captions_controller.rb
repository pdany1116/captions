# frozen_string_literal: true

require "./lib/memefier"

class CaptionsController < ApplicationController
  def index
    captions = Caption.all

    render json: { captions: captions }, status: :ok
  end

  def show
    caption = Caption.find(params[:id])

    render json: { caption: caption }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    errors = not_found_error(e.message)
    render json: { errors: [errors] }, status: :not_found
  end

  def create
    attributes = params.require(:caption).permit(:url, :text)
    attributes.fetch(:url)
    attributes.fetch(:text)

    caption = Caption.new(attributes)

    if caption.valid?
      image_name = "#{Digest::MD5.hexdigest("#{caption.url}#{caption.text}")}.jpg"

      ImageDownloader.download(caption.url, image_name)
      Memefier.memefy(caption.text, image_name)
      caption.caption_url = "/images/#{image_name}"
      caption.save

      render json: { caption: caption }, status: :created if caption.valid?
    else
      errors = caption.errors.map { |err| invalid_parameters_error(err.full_message) }

      render json: { errors: errors }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing, ImageDownloaderError => e
    errors = invalid_parameters_error(e.original_message)
    render json: { errors: [errors] }, status: :bad_request
  end

  def destroy
    caption = Caption.find(params[:id])

    if caption.destroy
      render status: :ok
    else
      errors = caption.errors.map { |err| invalid_parameters_error(err.full_message) }

      render json: { errors: errors }, status: :internal_server_error
    end
  rescue ActiveRecord::RecordNotFound => e
    errors = not_found_error(e.message)
    render json: { errors: [errors] }, status: :not_found
  end

  private

  def invalid_parameters_error(description)
    {
      code: "invalid_parameters",
      title: "Invalid parameters in request body",
      description: description
    }
  end

  def not_found_error(description)
    {
      code: "not_found",
      title: "Caption not found",
      description: description
    }
  end
end
