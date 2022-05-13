# frozen_string_literal: true

require_relative "generic_error_message"

class CaptionNotFoundErrorMessage < GenericErrorMessage
  def initialize(description)
    super("Caption not found", description, "caption_not_found")
  end
end
