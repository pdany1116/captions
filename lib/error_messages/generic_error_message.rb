# frozen_string_literal: true

class GenericErrorMessage
  attr_reader :title, :description, :code

  def initialize(title, description, code = "generic_error")
    @title = title
    @description = description
    @code = code
  end

  def body
    {
      code: @code,
      title: @title,
      description: @description
    }
  end
end
