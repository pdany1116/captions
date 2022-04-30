# frozen_string_literal: true

class CaptionsController < ApplicationController
  def index
    captions = Caption.all

    render json: { captions: captions }, status: :ok
  end

  def create
    attributes = params.require(:caption).permit(:url, :text)
    caption = Caption.create(attributes)

    render json: { caption: caption }, status: :created
  rescue ActionController::ParameterMissing
    render json: { errors: [invalid_parameters_error] }, status: :bad_request
  end

  private

  def invalid_parameters_error
    {
      code: "invalid_parameters",
      title: "Invalid parameters in request body",
      description: "Caption root element not present in request body"
    }
  end
end
