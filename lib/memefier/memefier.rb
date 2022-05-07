require "mini_magick"

class Memefier
  def self.memefy(source, text)
    image = MiniMagick::Image.open("./tmp/" + source)
    
    image.combine_options do |options|
      options.gravity "south"
      options.font "Umpush-Bold"
      options.fill "White"
      options.pointsize "100"
      options.stroke "Black"
      options.strokewidth "2"
      options.draw "text 0,0 '#{text}'"
    end

    image.write("./tmp/" + source)
  end
end
