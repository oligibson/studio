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
      @output_dir = output_dir || @config.output_directory
    end

    def create(prompt = nil)
      # TODO: Options to Add: Duration, Image
      @provider.film(prompt: prompt, model: @model)
    end

    def status(id)
      @provider.film_status(id, model: @model)
    end

    def download(id)
      response = @provider.download(id)
      file_path = prepare_output_path(@output_dir, id)
      write_stream(response, file_path)
      file_path
    end

    def with_model(model_id, provider: nil)
      @model, @provider = Models.resolve(model_id, provider:, config: @config)
      self
    end
  end
end
