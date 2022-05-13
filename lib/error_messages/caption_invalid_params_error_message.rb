# frozen_string_literal: true

require_relative "generic_error_message"

class CaptionInvalidParamsErrorMessage < GenericErrorMessage
  def initialize(description)
    super("Invalid parameters in request body", description, "invalid_caption_parameters")
  end
end
