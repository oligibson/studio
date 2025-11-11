# frozen_string_literal: true

module Studio
  module Providers
    class Gemini
      # Video generation methods for the Gemini API integration
      module Video
        module_function

        def video_url
          "models/#{@model}:predictLongRunning"
        end

        def status_url(id, model:)
          "models/#{model.id}/operations/#{id}"
        end

        def download_url(id, model: nil)
          status = film_status(id, model:)
          uri = extract_video_uri(status)
          normalize_download_path(uri)
        end

        def render_video_payload(prompt, model:, seconds:, aspect_ratio:)
          @model = model.id
          {
            instances: [{
              prompt: prompt
            }],
            parameters: {
              durationSeconds: seconds,
              aspectRatio: aspect_ratio
            }
          }
        end

        def parse_video_response(response, prompt: nil, model: nil)
          data = response.body
          operations_path = data['name'] || data[:name]
          operation_id = operations_path.to_s.split('/').last

          Film.new(
            id: operation_id,
            model_id: model&.id,
            prompt: prompt
          )
        end

        def parse_status_response(response)
          response.body
        end

        def parse_download_response(response)
          response.body
        end

        def extract_video_uri(status)
          unless video_generation_complete?(status)
            raise Errors::VideoNotReadyError,
                  'Video generation still in progress'
          end

          response = indifferent_hash(status)['response']
          generate_response = indifferent_hash(response).fetch('generateVideoResponse', nil)
          samples = Array(generate_response && generate_response['generatedSamples'])
          sample = samples.first || raise(Errors::DownloadUnavailableError, 'No generated video samples available')
          video = indifferent_hash(sample)['video'] || {}
          uri = indifferent_hash(video)['uri']
          raise Errors::DownloadUnavailableError, 'Download URI missing from Gemini response' unless uri

          uri
        end

        def normalize_download_path(uri)
          return uri unless uri

          path = uri.split('/v1beta/').last || uri
          path.sub(%r{^/}, '')
        end

        def video_generation_complete?(status)
          indifferent_hash(status).fetch('done', false)
        end

        def indifferent_hash(value)
          case value
          when Hash
            value.transform_keys(&:to_s)
          else
            {}
          end
        end
      end
    end
  end
end
