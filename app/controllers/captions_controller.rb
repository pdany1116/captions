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

    render json: { errors: caption.errors.map do |err|
                             invalid_parameters_error(err.full_message)
                           end }, status: :unprocessable_entity
  rescue ActionController::ParameterMissing => e
    render json: { errors: [invalid_parameters_error(e.original_message)] }, status: :bad_request
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
