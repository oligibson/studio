# frozen_string_literal: true

module Studio
  # Global Config
  class Configuration
    attr_accessor :openai_api_key,
                  :gemini_api_key,
                  :default_model,
                  :output_directory,
                  :default_aspect_ratio

    def initialize
      @default_model = 'sora-2'
      @default_aspect_ratio = '9:16'
      @output_directory = 'videos'
    end
  end
end
