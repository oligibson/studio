# frozen_string_literal: true

require 'fileutils'
require 'faraday'
require 'faraday/follow_redirects'
require 'json'
require 'jwt'
require 'zeitwerk'

# A Ruby interface to AI Video Generation models.
module Studio
  Loader = Zeitwerk::Loader.new
  Loader.push_dir(File.join(__dir__, 'studio'), namespace: self)
  Loader.setup

  class << self
    def video(...)
      Video.new(...)
    end

    def models
      Models.instance
    end

    def providers
      Provider.providers.values
    end

    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end
end

Studio::Provider.register :openai, Studio::Providers::Openai
Studio::Provider.register :gemini, Studio::Providers::Gemini
Studio::Provider.register :kling, Studio::Providers::Kling
