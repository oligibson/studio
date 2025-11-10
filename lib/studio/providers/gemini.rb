# # frozen_string_literal: true

module Studio
  module Providers
    # Gemini integration.
    class Gemini < Provider
      include Gemini::Video
      include Gemini::Capabilities

      def api_base
        'https://generativelanguage.googleapis.com/v1beta'
      end

      def headers
        {
          'x-goog-api-key' => @config.gemini_api_key
        }.compact
      end

      class << self
        def configuration_requirements
          %i[gemini_api_key]
        end
      end
    end
  end
end
