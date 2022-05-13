# frozen_string_literal: true

require "mini_magick"

class Memefier
  @config = OpenStruct.new(images_dir: 'images/')

  class << self
    attr_reader :config

    def configure
      yield(@config)
    end

    def file_path(file_name)
      "#{@config.images_dir}/#{file_name}"
    end

    def memefy(text, file_name)
      image = MiniMagick::Image.open(file_path(file_name))
      
      image.combine_options do |options|
        options.gravity "south"
        options.font "Umpush-Bold"
        options.fill "White"
        options.pointsize "100"
        options.stroke "Black"
        options.strokewidth "2"
        options.draw "text 0,0 '#{text}'"
      end

      image.write(file_path(file_name))
    end
  end
end
