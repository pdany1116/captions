# frozen_string_literal: true

class Caption < ApplicationRecord
  validates :url, :text, presence: true
  validates :text, length: { maximum: 266 }
end
