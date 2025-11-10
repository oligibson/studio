# frozen_string_literal: true

module Studio
  module Providers
    class Openai
      # Determines the supported capabilities of Gemini models.
      module Capabilities
        module_function

        def supported_aspect_ratios(model_id)
          ['16:9', '9:16']
        end

        def validate_parameters!(model_id:, seconds:, aspect_ratio:)
          ensure_supported!(input: aspect_ratio, parameter: 'aspect ratio', allowed: supported_aspect_ratios(model_id))
        end

        def ensure_supported!(input:, parameter:, allowed:)
          return unless allowed

          normalized = input.to_s
          return if allowed.include?(normalized)

          raise Errors::UnsupportedParameter, "Unsupported #{parameter} '#{input}'. Allowed: #{allowed.join(', ')}"
        end
      end
    end
  end
end
