# frozen_string_literal: true

module Studio
  # Registry of avaliable AI Video Generation Models
  class Models
    class << self
      def instance
        @instance ||= new
      end

      def models_file
        File.expand_path('models.json', __dir__)
      end

      def resolve(model_id, provider: nil, config: nil)
        model = find(model_id, provider)
        # TODO: Add a check to ensure the provider is configured to be used.
        provider ||= model['provider']
        [model['id'], provider]
      end

      def find(model_id, provider = nil)
        if provider
          find_with_provider(model_id, provider)
        else
          find_without_provider(model_id)
        end
      end

      def initialize(models = nil)
        @models = models || load_models
      end

      def load_models
        read_from_json
      end

      def read_from_json
        data = File.exist?(models_file) ? File.read(models_file) : '[]'
        JSON.parse(data)
      rescue JSON::ParserError
        []
      end

      def all
        @models ||= load_models
      end

      private

      def find_with_provider(model_id, provider)
        all.find { |m| m['id'] == model_id && m['provider'] == provider } ||
          raise(Studio::Errors::ModelNotFoundError, "Model '#{model_id}' not found with provider '#{provider}'")
      end

      def find_without_provider(model_id)
        all.find { |m| m['id'] == model_id } ||
          raise(Studio::Errors::ModelNotFoundError, "Model '#{model_id}' not found")
      end
    end
  end
end
