# frozen_string_literal: true

module Studio
  # Base class for all providers
  class Provider
    attr_reader :config, :connection

    def initialize(config)
      @config = config
      @connection = Connection.new(self, @config)
    end

    def api_base
      raise NotImplementedError
    end

    def headers
      {}
    end

    def slug
      self.class.slug
    end

    def name
      self.class.name
    end

    def configuration_requirements
      self.class.configuration_requirements
    end

    def film(model:, seconds:, aspect_ratio:, prompt: nil)
      validate_parameters!(model_id: model.id, seconds:, aspect_ratio:)

      payload = render_video_payload(prompt, model:, seconds:, aspect_ratio:)
      response = @connection.post video_url, payload
      parse_video_response(response, prompt: prompt, model: model)
    end

    def film_status(id, model:)
      url = status_url(id, model:)
      response = @connection.get url
      parse_status_response(response)
    end

    def download(id, model: nil)
      url = download_url(id, model:)
      response = @connection.get url
      parse_download_response(response)
    end

    class << self
      def name
        to_s.split('::').last
      end

      def slug
        name.downcase
      end

      def configuration_requirements
        []
      end

      def register(name, provider_class)
        providers[name.to_sym] = provider_class
      end

      def resolve(name)
        providers[name.to_sym]
      end

      def providers
        @providers ||= {}
      end
    end
  end
end
