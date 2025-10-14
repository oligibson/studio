# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'openai'
require 'zeitwerk'

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

    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end
end
