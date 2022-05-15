# frozen_string_literal: true

class User < ApplicationRecord
  include BCrypt

  has_many :tokens

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
