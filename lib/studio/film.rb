# frozen_string_literal: true

# A simple way to interface with AI video models
module Studio
  # Represents a conversation with a video genetrating ai model
  class Film
    include Utils

    attr_reader :id, :model_id, :prompt

    def initialize(id: nil, model_id: nil, prompt: nil)
      @config = Studio.config
      @id = id
      @prompt = prompt
      @model_id = model_id
      @output_dir = @config.output_directory
      with_model(model_id)
    end

    def status
      @provider.film_status(@id, model: @model)
    end

    def save(path = nil)
      response = @provider.download(@id, model: @model)
      file_path = path || prepare_output_path(@output_dir, @id)
      write_stream(response, file_path)
      file_path
    end

    def with_model(model_id, provider: nil)
      @model, @provider = Models.resolve(model_id, provider:, config: @config)
      self
    end
  end
end
