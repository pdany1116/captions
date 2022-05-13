# frozen_string_literal: true

require './lib/memefier'
require './lib/utils'

Memefier.configure do |config|
  config.images_dir = Utils.images_dir
end
