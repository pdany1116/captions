# frozen_string_literal: true

require "./lib/memefier"
require "./lib/error_messages"

class CaptionsController < ApplicationController
  def index
    captions = Caption.all

    render json: { captions: captions }, status: :ok
  end

  def show
    caption = Caption.find(params[:id])

    render json: { caption: caption }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    error = CaptionNotFoundErrorMessage.new(e.message).body
    render json: { errors: [error] }, status: :not_found
  end

  def create
    attributes = validate_params(params)
    caption = Caption.new(attributes)

    if caption.valid?
      image_name = "#{Digest::MD5.hexdigest("#{caption.url}#{caption.text}")}.jpg"

      ImageDownloader.download(caption.url, image_name)
      Memefier.memefy(caption.text, image_name)
      caption.caption_url = "/images/#{image_name}"
      caption.save

      CaptionMailer.creation_success_email(caption).deliver_now

      render json: { caption: caption }, status: :created
    else
      errors = caption.errors.map { |err| CaptionInvalidParamsErrorMessage.new(err.full_message).body }

      render json: { errors: errors }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing, ImageDownloaderError => e
    error = CaptionInvalidParamsErrorMessage.new(e.original_message).body
    render json: { errors: [error] }, status: :bad_request
  end

  def destroy
    caption = Caption.find(params[:id])

    if caption.destroy
      render status: :ok
    else
      errors = caption.errors.map { |err| InvalidParasE(err.full_message) }

      render json: { errors: errors }, status: :internal_server_error
    end
  rescue ActiveRecord::RecordNotFound => e
    error = CaptionNotFoundErrorMessage.new(e.message).body
    render json: { errors: [error] }, status: :not_found
  end

  private

  def validate_params(params)
    attributes = params.require(:caption).permit(:url, :text)
    attributes.fetch(:url)
    attributes.fetch(:text)

    attributes
  end
end
