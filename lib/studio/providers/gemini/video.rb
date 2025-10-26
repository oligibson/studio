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

        def render_video_payload(prompt, model:)
          @model = model.id
          {
            instances: [{
              prompt: prompt
            }]
          }
        end

        def parse_video_response(response)
          # TODO: Create a new object with methods to manipulate video
          # response_body={"name"=>"models/veo-3.0-generate-001/operations/wji994j9dp9c"}
          response.body
        end

        def parse_status_response(response)
          puts response
          response.body
        end

        def download_url(id)
          "files/#{id}:download?alt=media"
        end

        def parse_download_response(response)
          response
        end
      end
    end
  end
end
