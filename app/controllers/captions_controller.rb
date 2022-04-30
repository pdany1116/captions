# frozen_string_literal: true

class CaptionsController < ApplicationController
  def index
    captions = Caption.all

    render json: { captions: captions }, status: :ok
  end

  def create
    attributes = params.require(:caption).permit(:url, :text)
    url = attributes.require(:url)

    caption = Caption.create(attributes)

    render json: { caption: caption }, status: :created
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
