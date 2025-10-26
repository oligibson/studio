# frozen_string_literal: true

module Studio
  # Connection class for managing API connections
  class Connection
    attr_reader :provider, :connection, :config

    def initialize(provider, config)
      @provider = provider
      @config = config

      # TODO: Check the provider is configured correctly
      @connection ||= Faraday.new(provider.api_base) do |faraday|
        setup_middleware(faraday)
      end
    end

    def post(url, payload, &)
      @connection.post url, payload do |req|
        req.headers.merge! @provider.headers if @provider.respond_to?(:headers)
        yield req if block_given?
      end
    end

    def get(url, &)
      @connection.get url do |req|
        req.headers.merge! @provider.headers if @provider.respond_to?(:headers)
        yield req if block_given?
      end
    end

    def delete(url, &)
      @connection.delete url do |req|
        req.headers.merge! @provider.headers if @provider.respond_to?(:headers)
        yield req if block_given?
      end
    end

    def instance_variables
      super - %i[@config @connection]
    end

    private

    def setup_middleware(faraday)
      faraday.request :json
      faraday.response :follow_redirects
      faraday.response :json
      faraday.adapter :net_http
    end
  end
end
