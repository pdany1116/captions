module ApiHelper
  def parsed_body
    JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :request
end
