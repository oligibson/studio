# frozen_string_literal: true

require 'openai'
require_relative 'utils'

# A simple way to interface with AI video models
module Studio
  # Represents a conversation with a video genetrating ai model
  class Video
    include Utils

    def initialize(output_dir: nil)
      @config = Studio.config
      @client ||= OpenAI::Client.new
      @output_dir = output_dir || @config.output_directory
    end

    def create(prompt: nil, **options)
      @client.videos.create({ prompt: prompt }.merge(options))
    end

    def download(id: nil)
      response = @client.videos.download_content(id)
      file_path = prepare_output_path(@output_dir, id)

      write_stream(response, file_path)

      file_path
    end

    def get(id: nil)
      @client.videos.retrieve(id)
    end
  end
end
