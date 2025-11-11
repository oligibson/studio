# frozen_string_literal: true

module Studio
  class Errors
    class ModelNotFoundError < StandardError; end
    class UnsupportedParameter < StandardError; end
    class VideoNotReadyError < StandardError; end
    class DownloadUnavailableError < StandardError; end
  end
end
