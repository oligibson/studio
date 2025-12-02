# frozen_string_literal: true

# VCR Configuration
VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  # Don't record new HTTP interactions when running in CI
  config.default_cassette_options = {
    record: ENV['CI'] ? :none : :once
  }

  # Create new cassette directory if it doesn't exist
  FileUtils.mkdir_p(config.cassette_library_dir)

  # Allow HTTP connections when necessary - this will fail PRs by design if they don't have cassettes
  config.allow_http_connections_when_no_cassette = true

  # Filter out API keys from the recorded cassettes
  config.filter_sensitive_data('<OPENAI_API_KEY>') { ENV.fetch('OPENAI_API_KEY', nil) }
  config.filter_sensitive_data('<GEMINI_API_KEY>') { ENV.fetch('GEMINI_API_KEY', nil) }

  # Filter our secret keys from the recorded cassettes
  config.filter_sensitive_data('<KLING_ACCESS_KEY>') { ENV.fetch('KLING_ACCESS_KEY', nil) }
  config.filter_sensitive_data('<KLING_SECRET_KEY>') { ENV.fetch('KLING_SECRET_KEY', nil) }

  config.filter_sensitive_data('<OPENAI_ORGANIZATION>') do |interaction|
    interaction.response.headers['Openai-Organization']&.first
  end

  config.filter_sensitive_data('<OPENAI_PROJECT>') do |interaction|
    interaction.response.headers['Openai-Project']&.first
  end

  # Filter cookies
  config.before_record do |interaction|
    if interaction.request.uri.include?('klingai.com')
      headers = interaction.request.headers['Authorization']
      next unless headers

      interaction.request.headers['Authorization'] =
        headers.map { 'Bearer <KLING_JWT>' }
    end

    if interaction.response.headers['Set-Cookie']
      interaction.response.headers['Set-Cookie'] = interaction.response.headers['Set-Cookie'].map { '<COOKIE>' }
    end
  end
end
