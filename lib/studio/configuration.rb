# frozen_string_literal: true

module Studio
  # Global Config
  class Configuration
    attr_accessor :openai_api_key,
                  :default_modal,
                  :output_directory

    def initialize
      @default_modal = 'sora-2'
      @output_directory = 'videos'
    end
  end
end
