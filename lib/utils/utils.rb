# frozen_string_literal: true

class Utils
  def self.images_dir
    if ENV["RAILS_ENV"] == "test"
      "spec/images/"
    else
      "images/"
    end
  end
end
