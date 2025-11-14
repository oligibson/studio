# frozen_string_literal: true

# A simple way to interface with AI video models
module Studio
  # Represents a conversation with a video genetrating ai model
  class Video
    include Utils

    attr_reader :aspect_ratio

    def initialize(model: nil, provider: nil, output_dir: nil, aspect_ratio: nil)
      # TODO: Options to Add: Resolution
      @config = Studio.config
      model_id = model || @config.default_model
      with_model(model_id, provider: provider)
      @output_dir = output_dir || @config.output_directory
      ratio = aspect_ratio || @config.default_aspect_ratio
      with_ratio(ratio)
    end

    def create(prompt = nil, seconds = 4)
      # TODO: Options to Add: Image
      @provider.film(prompt: prompt, seconds: seconds, aspect_ratio: @aspect_ratio, model: @model)
    end

    def status(id)
      @provider.film_status(id, model: @model)
    end

    def download(id)
      response = @provider.download(id, model: @model)
      file_path = prepare_output_path(@output_dir, id)
      write_stream(response, file_path)
      file_path
    end

    def with_model(model_id, provider: nil)
      @model, @provider = Models.resolve(model_id, provider:, config: @config)
      self
    end

    def with_ratio(ratio)
      normalized = ratio.to_s
      raise ArgumentError, "Unsupported aspect ratio: #{ratio}" unless %w[16:9 9:16].include?(normalized)

      @aspect_ratio = normalized
      self
    end
  end
end
