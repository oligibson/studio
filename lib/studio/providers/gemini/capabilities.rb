# frozen_string_literal: true

module Studio
  module Providers
    class Gemini
      # Determines the supported capabilities of Gemini models.
      module Capabilities
        module_function

        def supported_aspect_ratios
          ['16:9', '9:16']
        end

        def supported_resolutions
          %w[1080p 720p]
        end

        def supported_durations(model_id)
          case model_id
          when /veo-2.0-generate-001/ then %w[5 6 8]
          else
            %w[4 6 8]
          end
        end

        def validate_parameters!(model_id:, seconds:, aspect_ratio:)
          ensure_supported!(input: aspect_ratio, parameter: 'aspect ratio', allowed: supported_aspect_ratios)
          ensure_supported!(input: seconds, parameter: 'duration', allowed: supported_durations(model_id))
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
