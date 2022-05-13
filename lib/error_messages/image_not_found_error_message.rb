# frozen_string_literal: true

require_relative "generic_error_message"

class ImageNotFoundErrorMessage < GenericErrorMessage
  def initialize(description)
    super("Image not found", description, "image_not_found")
  end
end
