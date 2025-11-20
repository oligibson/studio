# frozen_string_literal: true

RSpec.shared_context 'with configured Studio' do
  before do
    Studio.configure do |config|
      config.openai_api_key = ENV.fetch('OPENAI_API_KEY', nil)
      config.gemini_api_key = ENV.fetch('GEMINI_API_KEY', nil)
      config.kling_access_key = ENV.fetch('KLING_ACCESS_KEY', nil)
      config.kling_secret_key = ENV.fetch('KLING_SECRET_KEY', nil)
    end
  end
end
