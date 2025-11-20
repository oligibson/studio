# frozen_string_literal: true

module Studio
  module Providers
    class Kling
      # Video generation methods for the KlingAI API integration
      module Video
        module_function

        def video_url(*segments)
          (['videos/text2video'] + segments.map(&:to_s)).join('/')
        end

        def status_url(id, model: nil) # rubocop:disable Lint/UnusedMethodArgument
          video_url(id)
        end

        def download_url(id, model: nil)
          status = film_status(id, model:)
          extract_video_uri(status)
        end

        def render_video_payload(prompt, model:, seconds:, aspect_ratio:)
          {
            model_name: model.id,
            prompt: prompt,
            aspect_ratio: aspect_ratio,
            duration: seconds.to_s
          }
        end

        def parse_video_response(response, prompt: nil, model: nil)
          data = response.body

          Film.new(
            id: data['data']['task_id'],
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

          data = indifferent_hash(status)['data'] || {}
          task_result = indifferent_hash(data)['task_result'] || {}
          videos = Array(task_result['videos'])
          video = videos.first || raise(Errors::DownloadUnavailableError, 'No generated videos available')
          uri = indifferent_hash(video)['url']
          raise Errors::DownloadUnavailableError, 'Video URL missing from Kling response' unless uri

          uri
        end

        def video_generation_complete?(status)
          data = indifferent_hash(status)['data'] || {}
          indifferent_hash(data)['task_status'].to_s == 'succeed'
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
