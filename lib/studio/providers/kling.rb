# frozen_string_literal: true

module Studio
  module Providers
    # Kling integration.
    class Kling < Provider
      include Kling::Video
      include Kling::Capabilities

      def api_base
        'https://api-singapore.klingai.com/v1'
      end

      def headers
        token = Studio::Utils.generate_jwt(
          access_key: @config.kling_access_key,
          secret_key: @config.kling_secret_key
        )

        {
          'Authorization' => "Bearer #{token}"
        }
      end

      class << self
        def configuration_requirements
          %i[kling_access_key kling_secret_key]
        end
      end
    end
  end
end
