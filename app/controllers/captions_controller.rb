# frozen_string_literal: true

class CaptionsController < ApplicationController
  def index
    captions = Caption.all

    render json: { captions: captions }, status: :ok
  end

  def create
    attributes = params.require(:caption).permit(:url, :text)
    attributes.fetch(:url)
    attributes.fetch(:text)

    caption = Caption.create(attributes)
    return render json: { caption: caption }, status: :created if caption.valid?

    errors = caption.errors.map { |err| invalid_parameters_error(err.full_message) }

    render json: { errors: errors }, status: :unprocessable_entity
  rescue ActionController::ParameterMissing => e
    errors = invalid_parameters_error(e.original_message)
    render json: { errors: [errors] }, status: :bad_request
  end

  private

  def invalid_parameters_error(description)
    {
      code: "invalid_parameters",
      title: "Invalid parameters in request body",
      description: description
    }
  end
end
