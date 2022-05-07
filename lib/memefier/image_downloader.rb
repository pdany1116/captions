require "down"
require "./lib/errors/image_downloader_error"

class ImageDownloader
  def download(uri, path)
    Down.download(uri, destination: "./tmp/#{path}")

  rescue Down::Error
    raise ImageDownloaderError.new("Invalid URI provided!")
  end

  def self.create
    @instance ||= new
  end

  private_class_method :new
end
