# frozen_string_literal: true

module Studio
  module Providers
    class Kling
      # Determines the supported capabilities of Kling models.
      module Capabilities
        module_function

        def supported_aspect_ratios
          ['16:9', '9:16', '1:1']
        end

        def supported_durations
          %w[5 10]
        end

        def validate_parameters!(model_id:, seconds:, aspect_ratio:) # rubocop:disable Lint/UnusedMethodArgument
          ensure_supported!(input: aspect_ratio, parameter: 'aspect ratio', allowed: supported_aspect_ratios)
          ensure_supported!(input: seconds, parameter: 'duration', allowed: supported_durations)
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
