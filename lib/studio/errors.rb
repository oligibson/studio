# frozen_string_literal: true

module Studio
  class Errors
    class ModelNotFoundError < StandardError; end
    class UnsupportedParameter < StandardError; end
  end
end
