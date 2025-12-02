# frozen_string_literal: true

RSpec.shared_context 'with configured Studio' do
  before do
    Studio.configure do |config|
      config.openai_api_key = ENV.fetch('OPENAI_API_KEY', 'test')
      config.gemini_api_key = ENV.fetch('GEMINI_API_KEY', 'test')
      config.kling_access_key = ENV.fetch('KLING_ACCESS_KEY', 'test')
      config.kling_secret_key = ENV.fetch('KLING_SECRET_KEY', 'test')
    end
  end
end
