# frozen_string_literal: true

RSpec.configure do |config|
  config.after do
    FileUtils.rm_r Dir.glob('./spec/images/*')
  end
end
