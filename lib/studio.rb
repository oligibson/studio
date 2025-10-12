# frozen_string_literal: true

require_relative 'studio/configuration'
require_relative 'studio/video'

# A simple way to interface with AI video models
module Studio
  DEFAULT_PROMPT = 'A calico cat playing a piano on stage'
  DEFAULT_VIDEO_ID = 'video_68ea55568c3481909803d8419082908c0a4b607f1758781e'

  class << self
    def video(...)
      Video.new(...)
    end

    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end
end
