# frozen_string_literal: true

require "./lib/error_messages"

class UsersController < ApplicationController
  skip_before_action :authenticate!

  def sign_up
    attributes = validate_params(params)
    user = User.new(attributes)

    if user.save
      token = user.tokens.create
      response = {
        token: {
          value: token.value
        }
      }
      
      render json: response, status: :created
    else
      errors = caption.errors.map { |err| UserInvalidParamsErrorMessage.new(err.full_message).body }

      render json: { errors: errors }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing => e
    error = UserInvalidParamsErrorMessage.new(e.original_message).body
    render json: { errors: [error] }, status: :bad_request
  end

  private

  def validate_params(params)
    attributes = params.require(:user).permit(:email, :password)
    attributes.fetch(:email)
    attributes.fetch(:password)

    attributes
  end
end
