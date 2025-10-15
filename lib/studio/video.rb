# frozen_string_literal: true

# A simple way to interface with AI video models
module Studio
  # Represents a conversation with a video genetrating ai model
  class Video
    include Utils

    def initialize(model: nil, provider: nil, output_dir: nil)
      # TODO: Options to Add: aspectRatio, Resolution
      @config = Studio.config
      model_id = model || @config.default_model
      with_model(model_id, provider: provider)
      @client ||= OpenAI::Client.new
      @output_dir = output_dir || @config.output_directory
    end

    def create(prompt = nil)
      # TODO: Options to Add: Duration, Image
      @client.videos.create(model: @model, prompt: prompt)
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

    def remix(id: nil, prompt: nil)
      @client.videos.remix(id, prompt: prompt)
    end

    def with_model(model_id, provider: nil)
      @model, @provider = Models.resolve(model_id, provider:, config: @config)
      self
    end
  end
end
