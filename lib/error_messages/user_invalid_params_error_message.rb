# frozen_string_literal: true

require_relative "generic_error_message"

class UserInvalidParamsErrorMessage < GenericErrorMessage
  def initialize(description)
    super("Invalid parameters in request body", description, "invalid_user_parameters")
  end
end
