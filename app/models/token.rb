# frozen_string_literal: true

class Token < ApplicationRecord
  default_scope { active }

  belongs_to :user

  before_validation :generate_value
  before_validation :set_expires_at

  scope :active, -> { where('expires_at > ?', Time.zone.now) }
  scope :by_value, ->(value) { where(value: value) }

  def generate_value
    self.value = SecureRandom.hex if value.nil?
  end

  def set_expires_at
    self.expires_at = 1.day.from_now if expires_at.nil?
  end
end
