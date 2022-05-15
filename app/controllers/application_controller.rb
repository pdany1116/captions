# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate!

  def authenticate!
    token_value = request.headers['X-Token']

    head 401 unless Token.by_value(token_value).exists?
  end
end
