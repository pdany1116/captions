# frozen_string_literal: true

require "down"
require_relative "image_downloader_error"

class ImageDownloader
  def self.download(uri, file_name)
    Down.download(uri, destination: Memefier.file_path(file_name))

  rescue Down::Error
    raise ImageDownloaderError.new("Invalid URI provided!")
  end
end
