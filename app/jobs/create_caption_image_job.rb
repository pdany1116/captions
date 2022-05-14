# frozen_string_literal: true

require "./lib/memefier"

class CreateCaptionImageJob < ApplicationJob
  queue_as :default

  discard_on ImageDownloaderError

  def perform(caption, image_name)
    ImageDownloader.download(caption.url, image_name)
    Memefier.memefy(caption.text, image_name)
  end
end
