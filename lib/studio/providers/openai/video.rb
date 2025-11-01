# frozen_string_literal: true

module Studio
  module Providers
    class Openai
      # Video generation methods for the OpenAI API integration
      module Video
        module_function

        def video_url(*segments)
          (['videos'] + segments.map(&:to_s)).join('/')
        end

        def render_video_payload(prompt, model:, seconds:, aspect_ratio:)
          size = aspect_ratio.to_s == '9:16' ? '720x1280' : '1280x720'
          {
            model: model.id,
            prompt: prompt,
            seconds: seconds.to_s,
            size: size
          }
        end

        def status_url(id, model:)
          video_url(id)
        end

        def download_url(id)
          video_url(id, 'content')
        end

        def parse_video_response(response)
          # TODO: Create a new object with methods to manipulate video
          response.body
        end

        def parse_status_response(response)
          response.body
        end

        def parse_download_response(response)
          response.body
        end
      end
    end
  end
end
