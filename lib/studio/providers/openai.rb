# frozen_string_literal: true

module Studio
  module Providers
    # OpenAI integration.
    class Openai < Provider
      include Openai::Video
      include Openai::Capabilities

      def api_base
        'https://api.openai.com/v1'
      end

      def headers
        {
          'Authorization' => "Bearer #{@config.openai_api_key}"
        }.compact
      end

      class << self
        def configuration_requirements
          %i[openai_api_key]
        end
      end
    end
  end
end
